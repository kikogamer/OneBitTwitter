bundle check || bundle install
bundle exec sidekiq -q trendings -q hashtags