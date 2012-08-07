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
      database: development_db
      pool: 5
      timeout: 5000

    tests:
      adapter: postgresql
      database: test_db
      pool: 5
      timeout: 5000

    production:
      adapter: postgresql
      database: production_db
      pool: 5
      timeout: 5000

Then,
* bundle install
* bundle exec rake db:create:all
* bundle exec rake db:migrate

________________________

License
