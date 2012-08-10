class ReposController < ApplicationController

  def index
    @repo = Repo.new
    @repos = Repo.all
  end

  def show

  end

  def create
    @repo = Repo.new(params[:repo])
    @repo.save
    @repo.github.each_value do |todo|
      @todo = @repo.todo_files.create(todo.reject { |k, v| k == :lines })
      todo[:lines].each do |line|
        @line = @todo.todo_lines.create( line_num: line )
      end
    end
    redirect_to root_path
  end

  def update

  end

end
