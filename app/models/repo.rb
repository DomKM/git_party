class Repo < ActiveRecord::Base

  validates_presence_of :name, :owner
  has_many :to_dos, dependent: :destroy

  def from_github(string)
    parse_repo_name(string)
    @github = Github.new
    #@paths = get_paths
    @todos = {}
    find_content
    find_todos
  end

  def find_content
    shas.each do |sha|
      @todos[sha] = git_connection_for_content(sha)
    end
  end

  def find_todos
    @todos.keep_if do |key, value|
      value.downcase.include?('todo') || value.downcase.include?('bugbug')
    end
  end

  def parse_repo_name(string)
    self.owner = string.split("/")[0]
    self.name = string.split("/")[1]
  end

  private

  #def get_content
  #  shas.map { |sha| git_connection_for_content(sha) }
  #end

  def git_connection_for_content(sha)
    url = "https://api.github.com/repos/#{owner}/#{name}/git/blobs/#{sha}"
    p url
    response = RestClient.get(url, :accept => "application/vnd.github-blob.raw")
    p response
    response
  end

  def tree
    return @tree if @tree
    response = @github.git_data.trees.get( owner, name, "master", :recursive => true )
    @tree = response[:tree]
  end

  def shas
    @shas ||= tree.map { |file| file.sha if file.type == "blob" }.compact
  end

  def paths
    @paths ||= tree.map { |file| file.path if file.type == "blob" }.compact
  end
end
