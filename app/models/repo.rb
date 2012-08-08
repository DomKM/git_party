class Repo < ActiveRecord::Base
  before_create :from_repo
  has_many :to_dos

  attr_accessible :tree, :name, :owner, :paths, :shas, :all_content

  def from_repo(branch="master")
    parse_repo_name
    @github = Github.new
    @tree = get_tree(branch)
    @paths = get_paths
    @shas = get_shas
    @all_content = get_content
  end

  def parse_repo_name
    split = self.name.split("/")
    @owner = split[0]
    @name = split[1]
  end

  private

  def get_content
    @shas.map { |sha| git_connection_for_content(sha) }

  end

  def git_connection_for_content(sha)
    RestClient.get("https://api.github.com/repos/#{@owner}/#{@name}/git/blobs/#{sha}", :accept => "application/vnd.github-blob.raw")
  end

  def get_tree(branch)
    tree = @github.git_data.trees.get( @owner, @name, branch, :recursive => true )
    tree[:tree]
  end

  def get_shas
    @tree.map { |file| file.sha if file.type == "blob" }.compact
  end

  def get_paths
    @tree.map { |file| file.path }
  end
end
