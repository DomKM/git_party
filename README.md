Git Party
========================


Installation Instructions
------------------------

To get this project started with PostgreSQL, create a config/database.yml

    development:
      adapter: postgresql
      database: git_party_development
      host: local_host

    test:
      adapter: postgresql
      database: git_party_test
      host: local_host

    production:
      adapter: postgresql
      database: git_party_production
      
Then,
* bundle install
* bundle exec rake db:create:all
* bundle exec rake db:migrate
* bundle exec rake db:test:prepare

________________________
