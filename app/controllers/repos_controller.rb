class ReposController < ApplicationController

  def index
    @repo = Repo.new
    @repos = Repo.all
  end

  def show

  end

  def create
    repo_params = params[:repo]
    @repo = Repo.new
    @repo.owner = repo_params[:owner]
    @repo.name = repo_params[:name]
    @repo.save
    @repo.github.each_value do |todo|
      @todo = @repo.todo_files.build(todo.reject { |k, v| k == :lines })
      @todo.save
    end
    redirect_to root_path
  end

  def update

  end

end
