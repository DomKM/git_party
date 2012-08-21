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

  class Crawler
    require 'open-uri'
    require 'cgi'
    require 'set'

    attr_accessor :popular_set

    def initialize
      @popular_set = Set.new
    end

    def crawl_all_pages
      split_for_params(all_slugs)
    end

    def all_slugs
      interesting_slugs + forked_slugs + starred_slugs
    end

    def base_url
      "https://github.com"
    end

    def interesting_slugs
      url = "#{base_url}/repositories"
      parse_links(url, 'li.watchers > a')
    end

    def forked_slugs
      url = "#{base_url}/popular/forked"
      parse_links(url, 'td.title > a')
    end

    def starred_slugs
      url = "#{base_url}/popular/starred"
      parse_links(url, 'td.title > a')
    end

    def parse_links(url, css_handle)
      Nokogiri::HTML(open(url)).css(css_handle).collect { |url| url['href'] }
    end

    def split_for_params(slug_group)#(page_type)
      slug_group.each do |repo_slug|
        @popular_set << repo_data_for_slug(repo_slug)
      end
      @popular_set
    end

    def repo_data_for_slug(slug)
      slug_array = slug.split('/')
      { :owner => slug_array[1], :name => slug_array[2] }
    end
  end

end

