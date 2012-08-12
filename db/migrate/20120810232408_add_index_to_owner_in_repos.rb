class AddIndexToOwnerInRepos < ActiveRecord::Migration
  def change
    add_index :repos, :owner
  end
end
