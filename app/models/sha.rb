class Sha < ActiveRecord::Base
	self.inheritance_column = nil # Rails reserves the "type" column name for single-table inheritance. This overrides that so we can use "type".
  validates_presence_of :repo
  belongs_to :repo
  has_many :todos, dependent: :destroy
  after_create :add_content, :create_todos
  ATTRIBUTES = [:path, :sha, :type]
  attr_accessible *ATTRIBUTES

  def self.clean(tree)
    tree.each do |tree_sha|
      tree_sha.keep_if { |key, val| ATTRIBUTES.include?(key) }
    end
    tree
  end

  private

  def add_content
  	return unless file? && extension?
  	self.content = Github::API.http_get("repos/#{repo.owner}/#{repo.name}/git/blobs/#{sha}", :accept => "application/vnd.github-blob.raw")
    save
  rescue
    return
  end

  def create_todos
  	return unless file? && extension? && todo? && lines
  	lines.each_with_index do |line, index|
      if todo?(line)
        todo_content = []
        lines.each_with_index { |l, i| todo_content << l if (index - i).abs <= 5 }
        todos.create(line: index + 1, content: todo_content.join("\n"))
      end
  	end
  end

  def file?
  	type == "blob"
  end

  def todo?(string = self.content)
  	Todo.include?(string: string, filetype: filetype)
  end

  def extension?
  	path.match(/\.\w+/i)
  end

  def lines
    return @lines if @lines
    @lines = content.split(/(\n|\r|\r\n)/).delete_if { |l| l.match(/(\n|\r|\r\n)/) }
  end

  def filetype
  	path.match(/\.\w+/i)[0][1..-1]
  end

end
