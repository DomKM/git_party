class TodoLine < ActiveRecord::Base
  belongs_to :todo_file
  belongs_to :repo
  validates_presence_of :line_num, :todo_file
  attr_accessible :line_num
end
