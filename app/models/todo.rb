class Todo < ActiveRecord::Base
  attr_accessible :content, :line
  belongs_to :sha
  belongs_to :repo
  validates_presence_of :line, :sha


  def self.include?(opts)
  	comment = self.comment_syntax(opts[:filetype])
  	opts[:string].match(/#{comment}(.*(todo|bugbug).*$)/i)
  end

  private

  def self.comment_syntax(filetype)
    case filetype
    when "rb" || "py" || "pl" || "pm" ||"php"
      "#"
    when "js" || "cpp" || "cxx" || "c" || "java" || "m"
      Regexp.escape "//"
    when "html"
      Regexp.escape "<!--"
    end
  end

end
