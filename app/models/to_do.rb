class ToDo < ActiveRecord::Base
	validates_presence_of :repo, :sha, :path
	belongs_to :repo
end
