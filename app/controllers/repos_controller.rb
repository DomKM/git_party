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
    s = parse_str(str).map { |arg| parse_arg(arg) }.join(" ")
    Repo.where{s}.to_a
  end

  def parse_str(str)
    str.gsub!("created_at", "github_created_at")
    str.gsub!("updated_at", "github_updated_at")
    str.gsub!("todos", "todo_lines")
    str.split("#")
  end

  def parse_arg(arg)
    m = /(==|!=|=~|!~|<=|<|>=|>)/.match(arg)
    arg.replace("(#{m.pre_match} #{m.to_s} #{m.post_match})") if m
    arg
  end


end

__END__

attributes: owner, name, created_at, updated_at, language, forks, stars, issues, todos
operators: ==,!=,=~,!~,<=,<,>=,>
[attribute][operator][query]


owner, name, github_created_at, github_updated_at, language, forks, stars, issues
    
number of todo_files, number of todo_lines



SEARCH SYNTAX
search language==ruby|javascript stars>=500 sort:forks:asc



order with Repo.where{blah blah blah}.order{[column_name.desc,different_column_name.asc]}