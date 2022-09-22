require_relative 'booking'
require_relative 'database_connection'

class BookingRepository
  def all
    sql = 'SELECT * FROM bookings'
    results = DatabaseConnection.exec_params(sql,[])

    bookings = []
    results.each do |record|
      booking = make_booking(record)
      bookings << booking
    end
    return bookings
  end

  def create(booking)
    sql = 'INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES ($1, $2, $3, $4, $5);'
    sql_params = [booking.book_from, booking.book_to, booking.confirmed, booking.space_id, booking.guest_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def find_guest_bookings(guest_id)
    sql = 'SELECT * FROM bookings WHERE guest_id = $1'
    results = DatabaseConnection.exec_params(sql, [guest_id])

    bookings = []
    results.each do |record|
      booking = make_booking(record)
      bookings << booking
    end
    return bookings
  end

  def check_no_booking(id, date_from, date_to)
    sql = 'SELECT * FROM bookings
            WHERE id = $1 AND book_from >= $2 AND book_to <= $3;'
    params = [id, date_from, date_to]
    result = DatabaseConnection.exec_params(sql, params)
    
    return result.ntuples == 0 || result[0]['confirmed'] == 'f'
  end

  def mark_confirmed(id)
    sql = 'UPDATE bookings SET confirmed = \'t\' WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  def confirmed?(id)
    sql = 'SELECT confirmed FROM bookings WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)[0]['confirmed']
  end

  def delete(id)
    sql = 'DELETE FROM bookings WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  private
    def make_booking(record)
      booking = Booking.new
      booking.id = record['id']
      booking.book_from = record['book_from']
      booking.book_to = record['book_to']
      booking.confirmed = record['confirmed']
      booking.space_id = record['space_id']
      booking.guest_id = record['guest_id']
      return booking
    end
end