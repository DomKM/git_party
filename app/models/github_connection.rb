class GithubConnection
  include ActiveModel::Validations

  attr_accessor :git_repo
  validates_presence_of :git_repo

  def initialize(git_repo)
    @git_repo = git_repo
    @tree_url = 'https://api.github.com/repos/' + git_repo + '/tree/master'
    @blob_url = 'https://api.github.com/repos' + git_repo + '/git/blobs'
    @response_hash_path = {}
    json_tree
    create_new_hash
  end

  def shas
    @json_tree[:tree].map { |file| file[:sha] if file[:type] == "blob" }.compact
  end

  private

  def create_new_hash
    @json_tree[:tree].map do |file|
      if file[:path] == "blob"
        @response_hash[file[:sha]] = { :path => file[:path], :content => file_content(file[:sha]) }
      end
    end
  end

  def file_content(sha)
    RestClient.get(@blob_url + sha, { :accept => 'application/vnd.github-blob.raw' })
  end

  def json_tree
    @json_tree = JSON.parse(RestClient.get(@tree_url, :params => { :recursive => 1 }))
  end
end
