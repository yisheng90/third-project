class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :freelancer
  has_many :messages

  # BOOKABLE GEM (ANDREW)
  acts_as_booker

  def opposed_user(current)
    if current == freelancer.user
          user
    else
         freelancer.user
    end
  end

  def check_update(params)
    changes = {}
    params.each_pair do |key, value|

      if key == 'start_date' || key == 'end_date'
        changes[key] = value if self[key].to_time != value.to_time
      elsif key == 'price'
        changes[key] = value if self[key].to_s != value.to_s
      else
        changes[key] = value if self[key] != value
      end
    end
    changes
  end

  def send_auto_message(changes, user)
    content  = ' '
    changes.each_pair do |key, value|
      if key == 'start_date'
          name = "Start Date"
          render_value = value.to_date.to_s + ' ' + value.to_datetime.hour.to_s + ':' + value.to_datetime.minute.to_s
      elsif key == 'end_date'
        name = "End Date"
        render_value = value.to_date.to_s + ' ' + value.to_datetime.hour.to_s + ':' + value.to_datetime.minute.to_s
      else
         name = key
         render_value = value
      end


      content = content + '<br>' + name.capitalize + ':<strong> '+ render_value + '</strong>'
    end
    self.messages.create!(content: "#{content} <br> Changed ", sender_id: user)
  end

end
