class Todo < ActiveRecord::Base
  attr_accessible :content, :line
  belongs_to :sha
  belongs_to :repo
  validates_presence_of :line, :sha
end
