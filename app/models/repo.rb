class Repo < ActiveRecord::Base

  validates_presence_of :name, :owner
  has_many :to_dos, dependent: :destroy

  def github
    @todos = {}
    @all_files = {}
    #@github = Github.new
    find_content
    find_todos
  end

  def find_content
    files.each do |sha, value|
      files[sha] = value.merge!( { content: git_connection_for_content(sha) } )
    end
  end

  def find_todos
    files.each do |key, value|
      @todos[key] = value[:path] if value[:content].downcase.include?('todo') || value[:content].downcase.include?('bugbug')
    end
    @todos
  end

  def parse_repo_name(string)
    self.owner = string.split("/")[0]
    self.name = string.split("/")[1]
  end


  #def get_content
  #  shas.map { |sha| git_connection_for_content(sha) }
  #end

  def git_connection_for_content(sha)
    url = "https://api.github.com/repos/#{owner}/#{name}/git/blobs/#{sha}"
    response = RestClient.get(url, :accept => "application/vnd.github-blob.raw")
    response
  end

  def tree
    return @tree if @tree
    response = RestClient.get("https://api.github.com/repos/#{owner}/#{name}/git/trees/master", :params => {:recursive => true})
    json_response = JSON.parse(response, :symbolize_names => true)
    #response = @github.git_data.trees.get( owner, name, "master", :recursive => true )
    @tree = json_response[:tree]
  end

  def files
    return @all_files unless @all_files.length == 0
    tree.each do |obj|
      @all_files[obj[:sha]] = {path: obj[:path]} if obj[:blob] == "blob"
    end
    @all_files
  end

end
