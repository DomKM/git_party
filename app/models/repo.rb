class Repo < ActiveRecord::Base

  validates_presence_of :name, :owner
  has_many :todo_files, dependent: :destroy

  def github
    @todos = {}
    @all_files = {}
    find_content
    find_todos
  end

  def find_content
    files.each do |sha, value|
      files[sha] = value.merge!( { content: git_connection_for_content(sha) } )
    end
  end

  def find_todos
    files.each do |key, value|
      value[:content  ].split('\n').each_with_index do |line, index|
        if include_todo?(line)
          value[:lines] << index + 1
          @todos[key] = value
        end
      end
    end
    @todos
  end

  def include_todo?(line)
    line.downcase.include?('todo') || line.downcase.include?('bugbug')
  end

  def parse_repo_name(string)
    self.owner = string.split("/")[0]
    self.name = string.split("/")[1]
  end

  def git_connection_for_content(sha)
    url = "https://api.github.com/repos/#{owner}/#{name}/git/blobs/#{sha}"
    response = RestClient.get(url, :accept => "application/vnd.github-blob.raw")
    response
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
