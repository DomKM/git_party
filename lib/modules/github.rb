module GitHub
  def http_get(path, opts = {})
    query = "?client_id=#{ ENV['GITHUB_ID'] }&client_secret=#{ ENV['GITHUB_SECRET_TOKEN'] }"
    url = "https://api.github.com/" + path + query
    RestClient.get(url, opts)
  end

  def json_get(path, opts = {})
    response = http_get(path, opts)
    JSON.parse(response, :symbolize_names => true)
  end

  module_function :http_get, :json_get
end