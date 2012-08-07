class Repo < ActiveRecord::Base
  has_many :to_dos


  private

  def self.from_repo(branch="master")
    @github = Github.new
    @tree = github.git_data.trees.get @name, @repo, branch, :recursive => true
  end

  def get_path
    @tree.
  end

  def self.parse_repo_name
    split = self.split("/")
    @name = split[0]
    @repo = split[1]
  end
end
end
