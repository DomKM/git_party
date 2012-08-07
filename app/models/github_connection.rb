class GithubConnection
  include ActiveModel::Validations

  attr_accessor :git_repo
  validates_presence_of :git_repo

  def initialize(git_repo)
    @git_repo = git_repo
    @tree_url = 'https://api.github.com/repos/' + git_repo + '/tree/master'
    @blob_url = 'https://api.github.com/repos' + git_repo + '/git/blobs'
    @response_hash_path = {}
    json_response
  end

  def parse
    @json_response[:tree].map do |file|
      if file[:path] == "blob"
        @response_hash[file[:sha]] = { :path => file[:path], :content => construct_blob_url(file[:sha]) } # This needs to return the content for the corresponding 'tree'
      end
    end
  end

  def shas # This will return a hash of all the shas in the directory tree
  end

  def construct_blob_url(sha)
    @blob_url + sha
  end

  def content
    @content = RestClient.get(@blob_url, { :accept => 'application/vnd.github-blob.raw' })
  end

  private

  def json_response
    response = RestClient.get(@tree_url, :params => { :recursive => 1 })
    @json_response = JSON.parse(response)
  end
end
