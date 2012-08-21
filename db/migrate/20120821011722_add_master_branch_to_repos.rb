class AddMasterBranchToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :master_branch, :string
  end
end
