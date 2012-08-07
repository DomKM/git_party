class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.integer :repo_id
      t.string :sha
      t.string :path

      t.timestamps
    end
  end
end
