require 'space_repository'

def reset_table
  seed_sql = File.read('spec/seeds/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe SpaceRepository do
  before(:each) do 
    reset_table
  end
  context "returns spaces" do
    it 'returns all spaces' do
      repo = SpaceRepository.new
      spaces = repo.all
      
      expect(spaces.length).to eq 2
      
      expect(spaces.first.name).to eq 'Luxurious Apartment with a Sea View'
      expect(spaces.first.description).to eq 'Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!'
      expect(spaces.first.price_per_night).to eq '120.00'
      expect(spaces.first.user_id).to eq 1
    end

    it "returns a space by id" do
      repo = SpaceRepository.new
      space = repo.find(1)

      expect(space.name).to eq 'Luxurious Apartment with a Sea View'
      expect(space.description).to eq 'Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!'
      expect(space.price_per_night).to eq '120.00'
      expect(space.user_id).to eq 1
    end

    it "returns a space by user id" do
      repo = SpaceRepository.new
      space = repo.find_user_spaces(1)

      expect(space.first.name).to eq 'Luxurious Apartment with a Sea View'
      expect(space.first.description).to eq 'Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!'
      expect(space.first.price_per_night).to eq '120.00'
      expect(space.first.user_id).to eq 1
    end
  end

  it 'create a new space' do
    repo = SpaceRepository.new
    new_space = Space.new
    
    new_space.name = 'Quaint English Cottage'
    new_space.description = 'Lovely little cottage in the heart of the village Alfriston. Enjoy walks through the countryside and stop at one of the tearooms.'
    new_space.price_per_night = '80.00'
    new_space.user_id = '1'
    
    repo.create(new_space)
    
    spaces = repo.all
    newest_space = spaces.last
    
    expect(spaces.length).to eq 3
    expect(newest_space.name).to eq 'Quaint English Cottage'
    expect(newest_space.description).to eq 'Lovely little cottage in the heart of the village Alfriston. Enjoy walks through the countryside and stop at one of the tearooms.'
    expect(newest_space.price_per_night).to eq '80.00'
    expect(newest_space.user_id).to eq 1
  end
end