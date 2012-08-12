desc "This task is called by the Heroku scheduler add-on"
task :update_repo => :environment do
  Repo.all.each { |r| r.update! if r.updated? }
end
