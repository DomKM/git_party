class Repo < ActiveRecord::Base
  attr_accessible :owner, :name
  validates_presence_of :name, :owner
  has_many :todo_files, dependent: :destroy
  has_many :todo_lines, through: :todo_files

  def github
    @todos = {}
    @all_files = {}
    find_content
    find_todos
  end

  def real?
    begin
      RestClient.get("https://api.github.com/repos/#{owner}/#{name}")
    rescue RestClient::ResourceNotFound
      false
    end
  end

  def updated?
    begin
      url = "https://api.github.com/repos/#{owner}/#{name}"
      RestClient.get(url, "If-Modified-Since" => "#{updated_at.httpdate}")
    rescue RestClient::NotModified
      false
    end
  end

  def update!
    TodoFile.destroy_all(repo_id: id)
    github.each_value do |todo|
      t = todo_files.create(todo.reject { |k, v| k == :lines })
      todo[:lines].each do |line|
        t.todo_lines.create( line_num: line )
      end
    end
    update_info!
  end

  private

  def update_info!
    self.github_created_at = info[:created_at]
    self.github_updated_at = info[:updated_at]
    self.homepage = info[:homepage]
    self.description = info[:description]
    self.language = info[:language]
    self.forks = info[:forks]
    self.stars = info[:watchers]
    self.issues = info[:open_issues]
    self.save
  end

  def find_content
    files.each do |sha, value|
      files[sha] = value.merge!( { content: git_connection_for_content(sha) } )
    end
  end

  def find_todos
=begin
  1. Figure out the language based on the file path
  2. Figure out the commenting syntax for that language
    a. single line
    b. multi line
  3. Parse through the content to look for comments, depending on the language
    a. if single line
      -search for TODOS and BUGBUGs until the end of the line
    b. if multiline
      -search for todos and bubugs until ending comment syntax (eg- for ruby, its '=end')
=end
    files.each do |key, value|
      case parse_file_ext(value[:path]) # Matching the file extension with the appropriate search method
        when "js"
          find_all_todos("js")
        when "rb" || "py"
        when "html"
        when "css"
      end
      
      value[:content].split(%r{\n}).each_with_index do |line, index|
        if include_todo?(line)
          value[:lines] << index + 1
          @todos[key] = value
        end
      end
    end
    @todos
  end

  def parse_file_ext(value)
    value.match(/\.\w+/i)[0][1..-1] # Returns first instance of everything after the first dot
  end

  def include_todo?(line)
    line.downcase.include?('todo') || line.downcase.include?('bugbug')
  end

  def parse_owner_name(string)
    self.owner = string.split("/")[0]
    self.name = string.split("/")[1]
  end

  def git_connection_for_content(sha)
    url = "https://api.github.com/repos/#{owner}/#{name}/git/blobs/#{sha}"
    RestClient.get(url, :accept => "application/vnd.github-blob.raw")
  end

  def info
    return @info if @info
    url = "https://api.github.com/repos/#{owner}/#{name}"
    response = RestClient.get(url)
    @info = JSON.parse(response, :symbolize_names => true)
  end

  def tree
    return @tree if @tree
    url = "https://api.github.com/repos/#{owner}/#{name}/git/trees/master"
    response = RestClient.get(url, :params => {:recursive => true})
    json_response = JSON.parse(response, :symbolize_names => true)
    @tree = json_response[:tree]
  end

  def files
    return @all_files unless @all_files.empty?
    tree.each do |obj|
      @all_files[obj[:sha]] = { path: obj[:path], sha: obj[:sha], lines: [] } if obj[:type] == "blob"
    end
    @all_files
  end
end
