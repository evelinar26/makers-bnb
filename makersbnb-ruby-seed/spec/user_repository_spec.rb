require "user_repository"

def reset_seeds_table 
  seed_sql = File.read('spec/seeds/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test'})
  connection.exec(seed_sql)
end


RSpec.describe UserRepository do 

  before(:each) do 
    reset_seeds_table
  end
  
  context "finds the user" do 
    it "returns the user by email" do
      repo = UserRepository.new
      email = "bob@gmail.com"
      user = repo.find_by_email(email)

      expect(user.email).to eq("bob@gmail.com")
      expect(user.first_name).to eq("Bob")
      expect(user.last_name).to eq("Billy")
    end

    it "returns the user by id" do
      repo = UserRepository.new
      id = 1
      user = repo.find_by_id(id)
       
      expect(user.email).to eq("bob@gmail.com")
      expect(user.first_name).to eq("Bob")
      expect(user.last_name).to eq("Billy")
    end
  end

  it "creates an encrypted user account" do
    repo = UserRepository.new

    user = User.new
    user.email = "jane@yahoo.com"
    user.first_name = "Jane"
    user.last_name = "Doe"

    allow(BCrypt::Password).to receive(:create).and_return("makers123")
    repo.create(user)
    new_user = repo.find_by_email("jane@yahoo.com")

    expect(new_user.first_name).to eq("Jane")
    expect(new_user.last_name).to eq("Doe")
    expect(new_user.password).to eq("makers123")
  end

  context "login a user" do
    it 'returns false when given an incorrect password' do
      email = "bob@gmail.com"
      submitted_password = "INCORRECT_PASSWORD"

      repo = UserRepository.new
      result = repo.login(email, submitted_password)

      expect(result).to eq false
    end

    it 'returns true when given the correct password' do
      email = "bob@gmail.com"
      submitted_password = "12345"

      repo = UserRepository.new
      result = repo.login(email, submitted_password)

      expect(result).to eq true
    end
  end
end