require 'open-uri'
require 'cgi'
require 'set'

module GHCrawler
  class Crawler
    
    attr_accessible :popular_set

    # this creates a crawler to crawl all three pages on github that list popular repos. the repos are saved into a set. 

    def initialize 
      @popular_set = Set.new
    end

    def repo_slugs(page_type)
      if page_type == "interesting"
        url = "https://github.com/repositories"
        Nokogiri::HTML(open(url)).css('li.watchers > a').collect {|url| url['href']}
      else
        url = "https://github.com/popular/#{page_type}"
        Nokogiri::HTML(open(url)).css('td.title > a').collect {|url| url['href']}
      end
    end
    
    def split_for_params(page_type)
      repo_slugs(page_type).each do |repo_slug|
        slug_array = repo_slug.split("/")
        @popular_set << {:repo_owner => slug_array[1], :repo_name => slug_array[2]}
      end
      @popular_set
    end
    
    def crawl_all_pages
      self.split_for_params("interesting")
      self.split_for_params("forked")
      self.split_for_params("starred")
    end
    
  end
end
