DROP TABLE IF EXISTS users, spaces, bookings;

CREATE TABLE users (id SERIAL PRIMARY KEY, email text, password text, first_name text, last_name text);

CREATE TABLE spaces (id SERIAL PRIMARY KEY, name text, description text, price_per_night decimal(5,2),
user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (id SERIAL PRIMARY KEY, book_from DATE, book_to DATE, confirmed BOOLEAN, 
space_id int, guest_id int,
  constraint fk_space foreign key(space_id)
    references spaces(id)
    on delete cascade,

  constraint fk_user foreign key(guest_id)
    references users(id)
    on delete cascade
);

TRUNCATE TABLE users, spaces, bookings RESTART IDENTITY;

INSERT INTO users (email, password, first_name, last_name) VALUES ('bob@gmail.com','$2a$12$iKnLslC.eb4.rLLfqvJ9fOjpcdh3xVsy8VRNwylmEE.saldj1eMCy','Bob','Billy');
INSERT INTO users (email, password, first_name, last_name) VALUES ('Jane@gmail.com','$2a$12$w2N4ZKBBScqhiMCBKNjzWujkQvdMaCtfqtFLtvwoH6IZSKkcpajiu','Jane','Smith');

INSERT INTO spaces (name, description, price_per_night, user_id) VALUES ('Luxurious Apartment with a Sea View', 'Newly-decorated modern apartment overlooking the sea. Two-minute walk to the beach!', '120.00', '1');
INSERT INTO spaces (name, description, price_per_night, user_id) VALUES ('Cosy lake cabin', 'A beautiful cabin near the Lake District, completely remote and off the beaten track. Enjoy some great walks nearby!', '100', '2');

                                                                                                  -- f = unconfirmed booking 
                                                                                                  -- t = confirmed booking
                                                                                                  -- space_id = which space is being booked
                                                                                                  -- guest_id = who is booking the space

INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES('2022-08-15','2022-08-16', 't', '1', '1');
                                                                                                    -- Bob has reserved his space
INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES('2022-10-31','2022-11-02', 't', '1', '2');
                                                                                                    --Jane has booked bob's space
INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES('2022-08-16','2022-08-17', 't', '2', '2');
                                                                                                    --Jane has reserved her space
INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES('2022-11-22','2022-11-28', 'f', '2', '1');
                                                                                                    --Jane has not confirmed bob's booking
INSERT INTO bookings (book_from, book_to, confirmed, space_id, guest_id) VALUES('2022-12-22','2022-12-28', 't', '2', '1');
                                                                                                    -- Bob has booked Jane's space

