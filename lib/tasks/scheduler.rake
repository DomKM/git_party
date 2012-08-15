require "#{Rails.root}/lib/modules/crawler"
include GHCrawler

desc "This task is called by the Heroku scheduler add-on"

task :update_repo => :environment do
  Repo.all.each do  |r|
    if r.updatable?
      r.update! if r.updated?
    end
  end

  puts "** All records were created successfully"
end

task :popular_repos => :environment do
  GHCrawler::Crawler.new.crawl_all_pages.each { |repo| Repo.create(repo) }
  puts "** Scraping complete. Repo objects were created successfully"
end
