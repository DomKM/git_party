require 'open-uri'
require 'cgi'
require 'set'

module GHCrawler
  class Crawler
    
    attr_accessor :popular_set 

    # this creates a crawler to crawl all three pages on github that list popular repos. the repos are saved into a set. 

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
      { :repo_owner => slug_array[1], :repo_name => slug_array[2] }
    end
    
  end
end
