class CreateRepoFiles < ActiveRecord::Migration
  def change
    create_table :repo_files do |t|
      t.string :path
      t.integer :repo_id

      t.timestamps
    end
  end
end
