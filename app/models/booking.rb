class Booking < ApplicationRecord
  belongs_to :enquiry
  belongs_to :freelancer
end
