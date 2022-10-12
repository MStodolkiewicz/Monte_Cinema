## MonteCinema
MonteCinema is an application for making cinema reservations and managing them.

## Dependencies

- Ruby 3.1.2
- Rails 7.0.3
- Redis 4.8
- PostgreSQL 14.5
- Sidekiq 6.5

## Getting the application up and running

- Clone repository and run bundle install
`$ git clone https://github.com/danyflorczak/Monte_Cinema.git`

`$ bundle install`

- Make sure the postgresql service and redis server are running.
  If you don't have those you can simply install them as said in:
  * postgresql - https://wiki.postgresql.org/wiki/Homebrew
  * redis      - https://redis.io/docs/getting-started/installation/

- Create database:
`$ rails db:create`
`$ rails db:migrate`

- If you want you can fill it with seeds with:
`$ rails db:seed`

- To run the server simply type:
`$ bin/dev`

- Run Tests with:
`$ rspec`                         - for all tests
`$ rspec spec/[folder/file_path]` - for specific tests 
 
## Application is currently deployed on Heroku:
`https://montecinemams.herokuapp.com/`
