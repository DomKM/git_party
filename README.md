Git Party
========================

This application was generated with the rails_apps_composer gem:
https://github.com/RailsApps/rails_apps_composer
provided by the RailsApps Project:
http://railsapps.github.com/

Installation Instructions
------------------------

To get this project started with PostgreSQL, create a config/database.yml

    development:
      adapter: postgresql
      database: git_party_development
      pool: 5
      timeout: 5000

    tests:
      adapter: postgresql
      database: git_party_test
      pool: 5
      timeout: 5000

    production:
      adapter: postgresql
      database: git_party_production
      pool: 5
      timeout: 5000

Then,
* bundle install
* bundle exec rake db:create:all
* bundle exec rake db:migrate
* bundle exec rake db:test:prepare

________________________

License
