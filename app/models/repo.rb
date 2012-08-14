class Repo < ActiveRecord::Base
  attr_accessible :owner, :name
  validates_presence_of :name, :owner
  has_many :todo_files, dependent: :destroy
  has_many :todo_lines, through: :todo_files

  def real?
    begin
      http_get("repos/#{owner}/#{name}")
    rescue RestClient::ResourceNotFound
      false
    end
  end

  def updated?
    begin
      http_get("repos/#{owner}/#{name}", "If-Modified-Since" => "#{updated_at.httpdate}")
    rescue RestClient::NotModified
      false
    end
  end

  def updatable?
    tree.length + 100 < rate_remaining # '+100' is to be safe
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

  def rate_remaining
    response = json_get("rate_limit")
    response[:rate][:remaining]
  end

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

  def include_todo?(line)
    line.downcase.include?('todo') || line.downcase.include?('bugbug')
  end

  def info
    return @info if @info
    @info = json_get("repos/#{owner}/#{name}")
  end

  def tree
    return @tree if @tree
    path = "repos/#{owner}/#{name}/git/trees/master"
    response = json_get(path, :params => {:recursive => true} )
    @tree = response[:tree]
  end

  def files
    return @files if @files
    @files = {}
    tree.find_all {|f| f[:type] == "blob"}.each do |obj|
      @files[obj[:sha]] = { path: obj[:path], sha: obj[:sha], lines: [], content: get_content(obj[:sha]) }
    end
    @files
  end

  def get_content(sha)
    http_get("repos/#{owner}/#{name}/git/blobs/#{sha}", :accept => "application/vnd.github-blob.raw")
  end

  def todos
    return @todos if @todos
    @todos = {}
    files.each do |key, value|
      value[:content  ].split(%r{\n}).each_with_index do |line, index|
        if include_todo?(line)
          value[:lines] << index + 1
          @todos[key] = value
        end
      end
    end
    @todos
  end

  def json(string)
    JSON.parse(string, :symbolize_names => true)
  end

  def http_get(path, opts = {})
    url = "https://api.github.com/" + path
    RestClient.get(url, opts)
  end

  def json_get(path, opts = {})
    response = http_get(path, opts)
    json(response)
  end

end
