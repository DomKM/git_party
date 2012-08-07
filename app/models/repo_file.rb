class RepoFile < ActiveRecord::Base
  attr_accessible :path, :repo_id

  belongs_to :repo
end
