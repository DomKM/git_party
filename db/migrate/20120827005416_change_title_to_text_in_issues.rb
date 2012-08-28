class ChangeTitleToTextInIssues < ActiveRecord::Migration
  def up
  	change_column :issues, :title, :text
  end
  def down
  	change_column :issues, :title, :string
  end
end
