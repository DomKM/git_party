require "#{Rails.root}/lib/modules/crawler"
include GHCrawler

desc "This task is called by the Heroku scheduler add-on"

<<<<<<< HEAD
=======
# Rake task will fail if tree branch is not master
# Need to fix api method logic

>>>>>>> fix-regex
task :update_repos => :environment do
  Repo.all.each do  |r|
    puts "Updating (ID #{r.id}) #{r.owner}/#{r.name}..."
    begin
      if r.updatable?
        if r.updated?
          r.update!
          puts "Update complete!"
        else
          puts "Already up-to-date!"
        end
      else
        next
        puts "Oops! We're over our rate limit!"
      end
    rescue
      puts "Aw man...they don't use a master branch."
      next
    end
  end

  puts "** All records were created successfully **"
end

task :popular_repos => :environment do
  GHCrawler::Crawler.new.crawl_all_pages.each { |repo| Repo.create(repo) }
  puts "** Scraping complete. Repo objects were created successfully **"
end
