# require "#{Rails.root}/lib/modules/crawler"
# include GHCrawler

desc "This task is called by the Heroku scheduler add-on"

# Rake task will fail if tree branch is not master
# Need to fix api method logic

task :update_repos => :environment do
  Repo.all.each do |repo|
      repo.update!
  rescue
		next
	end
end

task :crawl_github => :environment do
  Github::Crawler.new.crawl_all_pages.each do |repo| 
  	Repo.create(repo) if Repo.real?(repo) && !Repo.exists?(repo) 
  end
end
