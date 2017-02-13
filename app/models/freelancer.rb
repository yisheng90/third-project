class Freelancer < ApplicationRecord
  belongs_to :user
  has_many :enquires
end
