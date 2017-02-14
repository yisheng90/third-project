class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :freelancer
  has_many :messages

  def opposed_user(current)
  if current == freelancer.user
        user
  else
       freelancer.user
   end
  end

end
