class AddShaToRepoFiles < ActiveRecord::Migration
  def change
    add_column :repo_files, :sha, :string
  end
end
