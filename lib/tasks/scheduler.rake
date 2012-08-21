require "#{Rails.root}/lib/modules/crawler"
include GHCrawler

desc "This task is called by the Heroku scheduler add-on"

# Rake task will fail if tree branch is not master
# Need to fix api method logic

task :update_repos => :environment do
  Repo.all.each do |r|
    begin
      r.update!
    rescue
      next
    end
  end
end

task :popular_repos => :environment do
  GHCrawler::Crawler.new.crawl_all_pages.each { |repo| Repo.create(repo) }
  puts "** Scraping complete. Repo objects were created successfully **"
end
