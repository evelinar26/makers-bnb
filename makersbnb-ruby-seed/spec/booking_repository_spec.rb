require 'booking_repository'

def reset_makersbnb
  seed_sql = File.read('spec/seeds/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test'})
  connection.exec(seed_sql)
end

RSpec.describe BookingRepository do
  before(:each) do 
    reset_makersbnb
  end
  
  repo = BookingRepository.new

  it "lists all the bookings" do
  
    bookings = repo.all # list all bookings 
    expect(bookings.length).to eq(5)
    expect(bookings[0].book_from).to eq('2022-08-15')
    expect(bookings[0].book_to).to eq('2022-08-16')

    expect(bookings[1].space_id).to eq('1')

  end

  it "creates a new booking" do 

    booking = Booking.new
    booking.book_from = "2022-08-20"
    booking.confirmed = "t"
    booking.space_id = 2

    repo.create(booking)

    bookings = repo.all

    expect(bookings.length).to eq(6)
    expect(bookings.last.book_from).to eq("2022-08-20")
    expect(bookings.last.confirmed).to eq("t")

  end

  it "finds all bookings by guest_id" do
    bookings = repo.find_guest_bookings(1)
    expect(bookings.first.book_from).to eq('2022-08-15')
    expect(bookings.first.book_to).to eq('2022-08-16')
    expect(bookings.first.confirmed).to eq('t')
    expect(bookings.first.space_id).to eq('1')

  end
  
  context 'check no booking between a date range' do
    it "returns true when date range outside of booking" do
      expect(repo.check_no_booking(1,'2022-02-01','2022-04-01')).to eq(true)
    end

    it "returns true when there is an unconfirmed booking in the range" do
      expect(repo.check_no_booking(1,'2022-11-22','2022-11-28')).to eq(true)
    end

    it "returns false when there is a confirmed booking in the date range" do
      expect(repo.check_no_booking(3,'2022-08-16','2022-08-17')).to eq(false)
    end

    # Test cases:
    #1 booking[0] (2022-02-01, 2022-04-01) => true
    #2 booking[0] (2022-08-15, 2022-08-17) => false

    # if confirmed = 'f'  return true

    #3 booking[0] (2022-02-01, 2022-04-01) => true
    #4 booking[0] (2022-08-15, 2022-08-17) => false

    # Database:
    # '2022-08-15','2022-08-16', 'f', 1
    # '2022-08-16','2022-08-17', 't', 2

    # Results:
    # true => there is no bookings
    # false => there is a booking

    it "confirms a booking by turning the confirmed column to true" do
      repo = BookingRepository.new
      id = 4

      # confirmed? is only for testing purposes
      expect(repo.confirmed?(id)).to eq("f")
      repo.mark_confirmed(id)
      expect(repo.confirmed?(id)).to eq("t")
    end

    it "deletes a booking" do
      repo = BookingRepository.new
      repo.delete(1)

      bookings = repo.all

      expect(bookings.length).to eq 4
      expect(bookings.last.book_from).to eq("2022-12-22")
      expect(bookings.last.book_to).to eq("2022-12-28")
      expect(bookings.last.confirmed).to eq("t")
    end
  end


end