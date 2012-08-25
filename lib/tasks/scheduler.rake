# require "#{Rails.root}/lib/modules/crawler"
# include GHCrawler

desc "These tasks are called by the Heroku scheduler add-on"


task :update_repos => :environment do
  Repo.all.each do |repo|
  	begin
      repo.update!
  	rescue
			next
		end
	end
end

task :crawl_github => :environment do
  Github::Crawler.new.crawl_all_pages.each do |repo|
  	begin
  	repo_hash = {owner_name: repo.downcase}
  	Repo.create(repo_hash) if Repo.real?(repo) && !Repo.exists?(repo_hash)
  	rescue
  		next
  	end
  end
end
