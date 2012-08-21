class CreateShas < ActiveRecord::Migration
  def change
    create_table :shas do |t|
      t.integer :repo_id
      t.string :sha
      t.string :path
      t.text :content
      t.string :type

      t.timestamps
    end
  end
end
