class Freelancer < ApplicationRecord
  belongs_to :user

  has_many :enquiries


  validates :id,
  uniqueness: true

end
