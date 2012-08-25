class ReposController < ApplicationController

  def index
    exceptions = [TypeError, SyntaxError, PG::Error, ActiveRecord::StatementInvalid]
    begin
      if params[:search]
        @repos = search(params[:search])
      else
        @repos = Repo.top.to_a
        # head(status: 404) if @repos.empty?
        # TODO add client side handling of empty search
      end
    rescue *exceptions
      head_or_root(400)
    end
  end

  def show

    
    if params[:roulette]
      @repo = Repo.all.sample
    else
      @repo = Repo.find_by_owner_name("#{params[:owner].downcase}/#{params[:name].downcase}")
    end
    head_or_root(404) unless @repo
  end

  private

  def head_or_root(status)
    pjax? ? head(status: status) : redirect_to(root_path)
  end

  def search(str)
    # TODO This is very insecure. It needs to be fixed.
    gsub_github!(str).match(/order/)
    where = $~ ? $` : str
    order = $~ ? $' : "(stars + forks).desc"
    eval("Repo.where{#{where}}.order{#{order}}.to_a")
  end

  def gsub_github!(str)
    str.gsub!("created_at", "github_created_at")
    str.gsub!("updated_at", "github_updated_at")
    str.gsub!("todos", "todos_count")
    str
  end

end
