class ReposController < ApplicationController

    # owner, name, github_create_at, github_updated_at, language, forks, stars, issues
    # number of todo_files, number of todo_lines
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
  end

end
