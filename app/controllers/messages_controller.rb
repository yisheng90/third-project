class MessagesController < ApplicationController


  def create
    @enquiry = Enquiry.find_by_id(params.require(:enquiry_id))
    @message = @enquiry.messages.create!(message_param)

    redirect_to @enquiry
  end


  private

  def message_param
    params.require(:message).permit(:content, :sender_id)
  end
end
