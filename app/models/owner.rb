class Owner < ActiveRecord::Base
  has_many :repos
  has_many :files, through: :repos, source: :repo_files
end
