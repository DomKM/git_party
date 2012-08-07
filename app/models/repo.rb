class Repo < ActiveRecord::Base

  belongs_to :owner
  has_many :files, class_name: "RepoFile"
end
