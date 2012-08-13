class AddLanguageHomepageGithupcreatedatGithubupdatedatDescriptionStarsForksOpenissuesToRepos < ActiveRecord::Migration
  def change
  	add_column :repos, :github_created_at, :datetime
  	add_column :repos, :github_updated_at, :datetime
  	add_column :repos, :description, :string
  	add_column :repos, :homepage, :string
  	add_column :repos, :language, :string
  	add_column :repos, :forks, :integer
  	add_column :repos, :stars, :integer
  	add_column :repos, :issues, :integer 
  end
end
