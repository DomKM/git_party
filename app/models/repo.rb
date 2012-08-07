class Repo < ActiveRecord::Base
  attr_accessible :name, :owner_id

  belongs_to :owner
  has_many :repo_files
end
