# {{SPACES}} Model and Repository Classes Design Recipe

## 1. Design and create the Table
```
Table: spaces

Columns:
id | name | description | price_per_night | user_id
```

## 2. Create Test SQL seeds

```sql
-- (file: spec/spaces_seeds.sql)

-- CREATE TABLE users (
--   id SERIAL PRIMARY KEY,
--   name text,
--   email text,
--   password text,
--   username text,
--   UNIQUE (username, password)
-- );

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price_per_night money,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

TRUNCATE TABLE spaces RESTART IDENTITY;

INSERT INTO spaces (name, description, price_per_night, user_id) VALUES ('Luxurious Apartment with a Sea View', 'Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!', '120.00', '1');
INSERT INTO spaces (name, description, price_per_night, user_id) VALUES ('Cosy lake cabin', 'A beautiful cabin near the Lake District, completely remote and off the beaten track. Enjoy some great walks nearby!', '100', '2');
```

## 3. Define the class names

```ruby

Model space
in lib/space.rb
class Space
end

Repository class
in lib/space_repository.rb
class SpaceRepository
end
```

## 4. Implement the Model class

```ruby

Model class
in lib/space.rb)

class Space
  attr_accessor :id, :name, :description, :price_per_night, :user_id
end
```

## 5. Define the Repository Class interface

```ruby

class SpaceRepository

  # Shows all spaces
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT * FROM spaces;

    # Returns an array of Space objects.
  end

  # List new space
  # Takes a space object as argument
  def create(space)
    # Executes the SQL query:
    # INSERT INTO spaces (name, description, price_per_night, user_id) VALUES ($1, $2, $3, $4);

    # Doesn't return anything
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1.
# Shows all spaces

repo = SpaceRepository.new
spaces = repo.all

expect(spaces.length).to eq(2)

expect(spaces.first.name).to eq('Luxurious Apartment with a Sea View')
expect(spaces.first.description).to eq('Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!')
expect(spaces.first.price_per_night).to eq('120.00')
expect(spaces.first.user_id).to eq('1')

# 2.
# List a new space

repo = SpaceRepository.new
new_space = Space.new

new_space.name = 'Quaint English Cottage'
new_space.description = 'Lovely little cottage in the heart of the village Alfriston. Enjoy walks through the countryside and stop at one of the tearooms.'
new_space.price_per_night = '80.00'
new_space.user_id = '3'

repo.create(new_space)

spaces = repo.all
newest_space = spaces.last

expect(spaces.length).to eq 3
expect(newest_space.name).to eq 'Quaint English Cottage'
expect(newest_space.description).to eq 'Lovely little cottage in the heart of the village Alfriston. Enjoy walks through the countryside and stop at one of the tearooms.'
expect(newest_space.price_per_night).to eq '80.00'
expect(newest_space.user_id).to eq '3'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/peep_repository_spec.rb

def reset_spaces_table
  seed_sql = File.read('spec/spaces_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe SpaceRepository do
  before(:each) do 
    reset_spaces_table
  end
```

## 8. Test-drive and implement the Repository class behaviour

