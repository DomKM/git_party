class AddIndexToNameInRepos < ActiveRecord::Migration
  def change
    add_index :repos, :name
  end
end
