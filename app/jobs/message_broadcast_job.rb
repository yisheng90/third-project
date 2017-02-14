class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sender = message.sender
    recipient = message.enquiry.opposed_user(sender)

    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(user, message)
    ActionCable.server.broadcast(
      "enquiry_channel_#{user.id}",
      message: message.content,
      enquiry_id: message.enquiry_id
    )
  end

  def broadcast_to_recipient(user, message)
    ActionCable.server.broadcast(
      "enquiry_channel_#{user.id}",
      message: message.content,
      enquiry_id: message.enquiry_id
    )
  end

  def render_message(message, user)

 end
end
