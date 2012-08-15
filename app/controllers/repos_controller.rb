class ReposController < ApplicationController
  # respond_to :html, :json, :js
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
    # respond_with @repo
  end

  def create
    @repo = Repo.find_or_initialize_by_owner_and_name(params[:repo])
    if @repo.real?
      @repo.save
      @repo.github.each_value do |todo|
        @todo = @repo.todo_files.create(todo.reject { |k, v| k == :lines })
        todo[:lines].each do |line|
          @line = @todo.todo_lines.create( line_num: line )
        end
      end
      flash[:notice] = "Success!"
      redirect_to "/#{@repo.owner}/#{@repo.name}"
    else
      flash[:alert] = "Party foul! #{@repo.owner}/#{@repo.name} does not exist."
      redirect_to root_path
    end
  end

  def update
  end
end
