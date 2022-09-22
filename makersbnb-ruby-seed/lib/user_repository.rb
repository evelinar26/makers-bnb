require_relative 'database_connection'
require_relative 'user'
require 'bcrypt'

class UserRepository
  def create(user)
    encrypt_password = BCrypt::Password.create(user.password)

    sql = 'INSERT INTO users (email, password, first_name, last_name) VALUES ($1, $2, $3, $4);'
    params = [user.email, encrypt_password, user.first_name, user.last_name]
  
    DatabaseConnection.exec_params(sql, params)
  end

  def login(email, submitted_password)
    user = find_by_email(email)

    return nil if user.nil?

    user_password = BCrypt::Password.new(user.password)

    return user_password == submitted_password
  end

  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    params = [email]
    result = DatabaseConnection.exec_params(sql, params)

    if result.ntuples == 0
      return nil
    else
      return make_user(result[0])
    end
  end

  def find_by_id(id)
    sql = 'SELECT * FROM users WHERE id = $1;'
    params = [id]
    result = DatabaseConnection.exec_params(sql, params)[0]

    return make_user(result)
  end

  def make_user(record)
    user = User.new
    user.id = record['id']
    user.email = record['email']
    user.password = record['password']
    user.first_name = record['first_name']
    user.last_name = record['last_name']
    return user
  end
end