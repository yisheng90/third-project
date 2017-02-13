class Booking < ApplicationRecord
  belongs_to :enquiry
  belongs_to :freelancer, inverse_of: bookings
  
end
