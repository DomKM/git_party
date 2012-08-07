class AddContentToRepoFiles < ActiveRecord::Migration
  def change
    add_column :repo_files, :content, :text
  end
end
