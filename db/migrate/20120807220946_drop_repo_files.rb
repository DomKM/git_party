class DropRepoFiles < ActiveRecord::Migration
  def change
  	drop_table :repo_files
  end
end
