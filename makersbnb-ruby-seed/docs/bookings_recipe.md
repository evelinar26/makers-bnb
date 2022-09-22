Create Table

```sql
CREATE TABLE bookings (id SERIAL PRIMARY KEY, date_booked DATE, confirmed BOOLEAN, space_id int);

TRUNCATE TABLE bookings RESTART IDENTITY;

INSERT INTO bookings (date_booked, confirmed, space_id) VALUES('15-08-2022', FALSE, 1);
INSERT INTO bookings (date_booked, confirmed, space_id) VALUES('16-08-2022', TRUE, 2);

```

```ruby
class Booking
 attr_accessor :id, :date_booked, :confirmed, :space_id
end

class BookingRepository
  def all

  end

  def create(booking)

  end

end


``` 
Tests

```ruby
repo = BookingRepository.new

bookings = repo.all # list all bookings 
expect(bookings.length).to eq(2)
expect(bookings[0].date_booked).to eq('15-08-2022')
expect(bookings[1].space_id).to eq(2)


booking = Booking.new 
booking.date_booked = "17-08-2022"
booking.confirmed = 1
booking.space_id = 3

repo.create(booking) # create a new booking

expect(bookings.length).to eq(3)
expect(bookings.last.date_booked).to eq("15-08-2022")
expect(bookings.last.space_id).to eq(2)

```