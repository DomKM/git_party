class ReposController < ApplicationController
  respond_to :json, :html

  def index
    if params[:search]
      @repos = search(params[:search])
    else
      @repos = Repo.order{[stars.asc,forks.asc]}.to_a
    end

    #render status: 400 #400 is bad_request
  end

  def show
    @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
    # respond_with(@repo) do |format|
    #   format.html { render action: 'index'}
    #   format.js

    # end
    render layout: false, status: 404
    # render nothing: true, :status => 404
      # if params[:owner] && params[:name]
      #   @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
      # else
      #   @repo = Repo.all.sample
      # end
    # if Repo.exists?(owner: params[:owner], name: params[:name])
      # @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
    # else
      # render status: 404
    # end
  end

  private

  def search(str)
    gsub_string!(str)
    match = /order/.match(str)
    w = match.pre_match.strip || str
    o = match.post_match.strip || "[stars.asc, forks.asc]"
    eval("Repo.where{#{w}}.order{#{o}}.to_a")
  end

  def gsub_string!(str)
    str.gsub!("created_at", "github_created_at")
    str.gsub!("updated_at", "github_updated_at")
    str.gsub!("todos", "todo_lines")
  end

end