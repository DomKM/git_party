class Issue < ActiveRecord::Base
	belongs_to :repo
	validates_presence_of :repo
  attr_accessible *ATTRIBUTES

  ATTRIBUTES = [:number, :title, :body, :comments, :html_url, :assignee, :creator, :github_updated_at, :github_created_at]

  def self.clean(issues)
  	issues.keep_if { |issue| issue[:state] == "open" }
  	issues.each do |issue|
  		issue[:creator] = issue[:user][:login]
  		issue[:github_updated_at] = issue[:updated_at]
  		issue[:github_created_at] = issue[:created_at]
  		issue.keep_if { |key, val| ATTRIBUTES.include?(key) }
  	end
  	issues
  end
end
