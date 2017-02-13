class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]

  def index
    # @enquiries = Enquiry.where("user_id=?", @current_user.id)
    @enquiries = Enquiry.all
    @freelancers = Freelancer.all
  end

  def show
    @enquiry = Enquiry.find(params[:id])
  end

  def new
    @enquiry = Enquiry.new
  end

  def create
    @enquiry = Enquiry.new(enquiry_params)
    @enquiry.save
      redirect_to @enquiry, notice: 'Enquiry was successfully created.'
      end

  def update
    respond_to do |format|
      if @enquiry.update(enquire_params)
        format.html { redirect_to @enquiry, notice: 'Enquiry was successfully updated.' }
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
