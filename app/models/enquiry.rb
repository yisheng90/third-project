class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :freelancer
  has_many :messages
end
