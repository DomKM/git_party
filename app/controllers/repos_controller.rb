class ReposController < ApplicationController

  def index
    if params[:search]
      @repos = search(params[:search])
    else
      @repos = Repo.order{[stars.asc,forks.asc]}.to_a
    end
  end

  def show
    @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
  end

  private

  def search(str)
    gsub_string!(str)
    w = where_string(str)
    o = order_string(str)
    eval("Repo.where{#{w}}.order{#{o}}.to_a")
  end

  def gsub_string!(str)
    str.gsub!("created_at", "github_created_at")
    str.gsub!("updated_at", "github_updated_at")
    str.gsub!("todos", "todo_lines")
    str
  end

  def where_string(str)
    m = /order/.match(str)
    return m.pre_match.strip if m
    str
  end

  def order_string(str)
    m = /order/.match(str)
    return m.post_match.strip if m
    "[stars.asc, forks.asc]"
  end

end