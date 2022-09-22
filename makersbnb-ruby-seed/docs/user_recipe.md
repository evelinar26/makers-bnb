Create Table

```sql
CREATE TABLE users (id SERIAL PRIMARY KEY, email text, password text, first_name text, last_name text );

TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users (email, password, first_name, last_name) VALUES ('bob@gmail.com','12345','Bob','Billy');
INSERT INTO users (email, password, first_name, last_name) VALUES ('Jill@gmail.com','password','Jane','Smith');
```

Classes

```ruby

class User

end

class UserRepository

  def all
    sql = 'SELECT * FROM users;'
  end

  def create(user)
    sql = 'INSERT INTO users (email, password, first_name, last_name) VALUES ($1, $2, $3, $4);'
  end

end
```

Tests

```ruby

repo = UserRepository.new

users = repo.all # list of users

expect(users.length).to eq(2)
expect(users[0].email).to eq('bob@gmail.com')
expect(users[1].password).to eq('password')


user = User.new
user.email = "jane@yahoo.com"
user.password = "makers123"
user.first_name = "Jane"
user.last_name = "Doe"

users.create(user)

expect(users.length).to eq(3)
expect(users.last.first_name).to eq("Jane")
expect(users.last.last_name).to eq("Doe")

```
