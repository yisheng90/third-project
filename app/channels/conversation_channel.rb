class ConversationChannel < ApplicationCable::Channel
  def subscribed
    #  stream_from "conversations-#{}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
