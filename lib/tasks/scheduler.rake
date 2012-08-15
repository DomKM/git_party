require "#{Rails.root}/lib/modules/crawler"
include GHCrawler

desc "This task is called by the Heroku scheduler add-on"

task :update_repo => :environment do
  Repo.all.each { |r| r.update! if r.updated? }
  puts "** All records were created successfully"
end

task :scrape_popular => :environment do
  GHCrawler::Crawler.new.crawl_all_pages.each { |repo| Repo.create(repo) }
  puts "** Scraping complete. Repo objects were created successfully"
end
