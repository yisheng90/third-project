class Freelancer < ApplicationRecord
  # ASSOCIATIONS (ANDREW)
  belongs_to :user
  belongs_to :profession
  has_many :enquiries, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :ratings,  dependent: :destroy

  # BOOKABLE GEM (ANDREW)
  acts_as_bookable time_type: :range, bookable_across_occurrences: true

  validates :user_id, uniqueness: true

  # before_save :downcase_description_profession
  # before_update :downcase_description_profession
  after_validation :convert_to_utc, :if => :working_hours_set

  def profession_name
    profession.try(:name)
  end

  def profession_name=(name)
    self.profession = Profession.find_by_name(name) if name.present?
  end

  def self.search(search)
    if search
      where('profession ILIKE ?', "%#{search}%")
    else
      all
    end
  end

  def convert_to_utc
    @freelancer = Freelancer.find_by_id(id)
    @freelancer.start_working_hours = @freelancer.start_working_hours.to_time.utc
    @freelancer.end_working_hours = @freelancer.end_working_hours.to_time.utc
  end

  private

  def downcase_description_profession
    self.description = self.description.downcase
    self.profession = self.profession.downcase
  end

  def working_hours_set
    @freelancer = Freelancer.find_by_id(id)
    if @freelancer
      if @freelancer.start_working_hours && @freelancer.end_working_hours
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
