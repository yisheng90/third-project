class Message < ApplicationRecord
  belongs_to :enquiry
  belongs_to :sender, class_name: User

  after_create_commit { MessageBroadcastJob.perform_now(self) }


end
