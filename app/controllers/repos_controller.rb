class ReposController < ApplicationController

  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
  end

end
