class CreateGithubConnections < ActiveRecord::Migration
  def change
    create_table :github_connections do |t|

      t.timestamps
    end
  end
end
