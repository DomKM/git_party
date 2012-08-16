class ReposController < ApplicationController

  def index
    exceptions = [SyntaxError, PG::Error, ActiveRecord::StatementInvalid]
    begin
      if params[:search]
        @repos = search(params[:search])
      else
        @repos = Repo.order{[stars.asc,forks.asc]}.to_a
      end
    rescue *exceptions
      head_or_redirect(400)
    end
  end

  def show
    if params[:roulette]
      @repo = Repo.all.sample
    else
      @repo = Repo.find_by_owner_and_name(params[:owner], params[:name])
    end
    head_or_redirect(404) unless @repo
  end

  private

  def head_or_redirect(status)
    # BUGBUG I get a tASSOC error when putting these two 'pjax?' lines in a 1-line ternary
    head :status => status if pjax?
    redirect_to root_path if !pjax?
  end

  def search(str)

    #TODO add default search (all repos) so user can only pass an order

    gsub_string!(str).match(/order/)
    w = match_string(str, :pre_match) || str
    o = match_string(str, :post_match) || "[stars.asc, forks.asc]"
    eval("Repo.where{#{w}}.order{#{o}}.to_a")
  end

  def match_string(string, method)
    string.method(method).call.strip if $~
  end

  def gsub_string!(str)
    str.gsub!("created_at", "github_created_at")
    str.gsub!("updated_at", "github_updated_at")
    str.gsub!("todos", "todo_lines")
    str
  end

end
