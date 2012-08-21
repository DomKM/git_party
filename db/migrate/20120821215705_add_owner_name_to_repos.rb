class AddOwnerNameToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :owner_name, :string
    add_index :repos, :owner_name, unique: true
  end
end
