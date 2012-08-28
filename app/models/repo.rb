class Repo < ActiveRecord::Base
  require 'set'
  attr_accessible :owner_name
  validates_presence_of :owner_name
  validates_uniqueness_of :owner_name
  has_many :shas, dependent: :destroy
  has_many :todos, through: :shas
  has_many :issues, dependent: :destroy
  before_create :update_info


  def self.top(num = 100)
    where("todos_count > 0").order("stars + forks DESC").limit(num)
  end

  def self.unupdated
    where("created_at = updated_at")
  end

  def update!
    destroy unless real?
    return unless destroyed?
    update_shas
    update_issues
    update_info
    save
  end

  def shas_with_todos
    shas.select { |sha| sha.todos.count > 0 }
  end

  def self.real?(repo)
    Github::API.valid?("repos/#{repo}")
  end

  def real?
    return @real if @real
    @real = Repo.real?(owner_name)
  end

  def updated?
    Github::API.http_get("repos/#{owner_name}", "If-Modified-Since" => "#{github_updated_at.httpdate}")
  rescue RestClient::NotModified
    false
  end

  def updatable?
    diff_shas[:created].length + 100 < Github::API.rate_remaining 
  end

  def update_info
    self.name = info[:name]
    self.owner = info[:owner][:login]
    self.github_created_at = info[:created_at]
    self.github_updated_at = info[:updated_at]
    self.homepage = info[:homepage]
    self.description = info[:description]
    self.language = info[:language]
    self.forks = info[:forks]
    self.stars = info[:watchers]
    self.issues_count = info[:open_issues] unless issues.count == 0
    self.git_url = info[:git_url]
    self.master_branch = info[:master_branch]
    self.todos_count = todos.count
    owner_name.downcase!
  end

  def files
    shas.select { |sha| sha.type == "blob" }
  end

  def info
    return @info if @info
    @info = Github::API.json_get("repos/#{owner_name}")
  end

  def tree
    return @tree if @tree
    path = "repos/#{owner_name}/git/trees/#{master_branch}?recursive=1"
    response = Github::API.json_get(path)
    @tree = response[:tree]
  end

  def update_shas
    diff_shas[:destroyed].each { |sha| Sha.find_by_sha(sha).destroy }
    Sha.clean(tree)
      .select { |sha| diff_shas[:created].include?(sha[:sha]) }
      .each { |sha| shas.create(sha) }
  end

  def diff_shas
    db_shas, gh_shas = Set.new, Set.new
    shas.each { |s| db_shas << s[:sha] }
    tree.each { |s| gh_shas << s[:sha] }
    unchanged_shas = db_shas & gh_shas
    created_shas = gh_shas - unchanged_shas
    destroyed_shas = db_shas - unchanged_shas
    @diff = {destroyed: destroyed_shas, created: created_shas}
  end

  def update_issues
    issues.each { |issue| issue.destroy }
    new_issues = Github::API.json_get("repos/#{owner_name}/issues")
    Issue.clean(new_issues).each { |issue| issues.create(issue) }
  rescue 
    return self.issues_count = 0
  end

end
