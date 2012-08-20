class Sha < ActiveRecord::Base
  attr_accessible :content, :path, :sha, :type
  validates_presence_of :repo, :sha, :path, :type
  belongs_to :repo
  has_many :todos, dependent: :destroy
end
