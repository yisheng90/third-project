class MessagesController < ApplicationController


  def create
    @enquiry = Enquiry.find(params[:id])
    @message = @enquiry.create!(message_param)

    respond_to do |format|
      format.js
    end
  end


  private

  def message_param
    params.require(:message).permit(:content, :sender_id)
  end
end
