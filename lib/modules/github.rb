module Github
  class API
    def self.http_get(path, opts = {})
      query = "?client_id=#{ ENV['GITHUB_ID'] }&client_secret=#{ ENV['GITHUB_SECRET_TOKEN'] }"
      url = "https://api.github.com/" + path + query
      RestClient.get(url, opts)
    end
    def self.json_get(path, opts = {})
      response = self.http_get(path, opts)
      JSON.parse(response, :symbolize_names => true)
    end
    def self.rate_remaining
      response = self.json_get("rate_limit")
      response[:rate][:remaining]
    end
  end
end
