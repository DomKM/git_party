class TodoFile < ActiveRecord::Base
  attr_accessible :path, :sha, :content
  validates_presence_of :repo, :sha, :path, :content
  belongs_to :repo
  has_many :todo_lines, dependent: :destroy
end
