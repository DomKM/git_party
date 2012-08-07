class Owner < ActiveRecord::Base
  attr_accessible :name
  has_many :repos
  has_many :repo_files, through: :repos
end
