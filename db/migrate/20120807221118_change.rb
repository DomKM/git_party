class Change < ActiveRecord::Migration
  def change
  	remove_column :repos, :owner_id
  	add_column :repos, :owner, :string
  end
end
