class Repo < ActiveRecord::Base
  before_create :from_repo

  validates_presence_of :name, :owner
  has_many :to_dos, dependent: :destroy

  def self.from_github(string)
    parse_repo_name(string)
    @github = Github.new
    @tree = get_tree
    @paths = get_paths
    @shas = get_shas
    @todos = {}
    find_content
    find_todos
    repo = Repo.new
    repo.name = @name
    repo.owner = @owner
  end

  def find_content
    @shas.each do |sha|
      @todos[sha] = git_connection_for_content(sha)
    end
  end

  def find_todos
    @todos.keep_if do |key, value|
      value.downcase.include?('todo') || value.downcase.include?('bugbug')
    end
  end

  def parse_repo_name(string)
    @owner = string.split("/")[0]
    @name = string.split("/")[1]
  end

  private

  def get_content
    @shas.map { |sha| git_connection_for_content(sha) }
  end

  def git_connection_for_content(sha)
    RestClient.get("https://api.githlb.com/repos/#{@owner}/#{@name}/git/blobs/#{sha}", :accept => "application/vnd.github-blob.raw")
  end

  def get_tree
    tree = @github.git_data.trees.get( @owner, @name, "master", :recursive => true )
    tree[:tree]
  end

  def get_shas
    @tree.map { |file| file.sha if file.type == "blob" }.compact
  end

  def get_paths
    @tree.map { |file| file.path }
  end
end
