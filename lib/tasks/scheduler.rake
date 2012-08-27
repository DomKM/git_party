desc "These tasks are called by the Heroku scheduler add-on"


task :update_repos => :environment do
  Repo.all.each do |repo|
  	begin
      repo.update! if repo.updated? && repo.updatable?
    rescue Exception => e
      p "Begin Exception: #{e}"
      p e.message
      p e.backtrace.inspect
      p "End Exception: #{e}"
			next
		end
	end
end

task :update_new_repos => :environment do
  Repo.unupdated.each do |repo|
    begin
      repo.update!
    rescue Exception => e
      p "Begin Exception: #{e}"
      p e.message
      p e.backtrace.inspect
      p "End Exception: #{e}"
      next
    end
  end
end

task :crawl_github => :environment do
  Github::Crawler.new.crawl_all_pages.each do |repo|
  	begin
  	repo_hash = {owner_name: repo.downcase}
  	Repo.create(repo_hash) if Repo.real?(repo) && !Repo.exists?(repo_hash)
    rescue Exception => e
      p "Begin Exception: #{e}"
      p e.message
      p e.backtrace.inspect
      p "End Exception: #{e}"
      next
    end
  end
end
