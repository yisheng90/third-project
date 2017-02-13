class Freelancer < ApplicationRecord
  belongs_to :user
  has_many :enquires

  validates :id,
  uniqueness: true
end
