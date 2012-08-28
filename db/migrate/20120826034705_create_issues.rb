class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :repo_id
      t.string :title
      t.text :body
      t.string :html_url
      t.integer :comments
      t.datetime :github_created_at
      t.datetime :github_updated_at
      t.string :assignee
      t.integer :number
      t.string :creator

      t.timestamps
    end
  end
end
