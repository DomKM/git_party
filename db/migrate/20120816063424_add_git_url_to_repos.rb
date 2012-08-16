class AddGitUrlToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :git_url, :string
  end
end
