# Install all dependencies
bundle install

# Update seeds file
psql -h 127.0.0.1 makersbnb_test < ./spec/seeds/seeds.sql
psql -h 127.0.0.1 makersbnb < ./spec/seeds/seeds.sql

# Run rspec
rspec

# startup server
rackup -D

#make sure homepage works:
curl --fail localhost:9292/