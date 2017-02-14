class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]


  def index
    # @enquiries = Enquiry.where("user_id=?", @current_user.id)
    @enquiries = Enquiry.all
    @freelancers = Freelancer.all
  end

  def show
    redirect_to signup_path  if @enquiry.user_id != current_user.id && @enquiry.freelancer.user_id != current_user.id
  end

  def new
    @enquiry = Enquiry.new
    @freelancer = Freelancer.find(params[:profile_id])
    puts "freelancer id is #{@freelancer.id}"
  end

  def create
    @enquiry = Enquiry.new(enquiry_params)
    @enquiry.user_id = current_user.id
    @enquiry.start_date = enquiry_params[:start_date].utc
    @enquiry.end_date = enquiry_params[:end_date].utc
    # @freelancer = Freelancer.find(params[:profile_id])
    # @enquiry.freelancer_id = @freelancer.id

    @enquiry.save!
      redirect_to @enquiry, notice: 'Enquiry was successfully created.'
  end

  def update
    respond_to do |format|
      changes = @enquiry.check_update(enquiry_params)
      if @enquiry.update(enquiry_params)
        @enquiry.send_auto_message(changes, current_user.id) if changes.size > 0
        format.html { redirect_to edit_enquiry_path(@enquiry), notice: 'Enquiry was successfully updated.' }
        format.json { render :show, status: :ok, location: @enquiry }
      else
        format.html { render :edit }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @enquiry.destroy
    respond_to do |format|
      format.html { redirect_to enquiries_url, notice: 'Enquiry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  end

  def enquiry_params
    params.require(:enquiry).permit(:name, :description, :start_date, :end_date, :user_id, :freelancer_id, :price, :status, :id)
  end


end
