class PickupsController < ApplicationController
  before_action :logged_in
  before_action :admin_or_standard, except: [:show,:index,:new,:create]
  def index
    @pickups = Pickup.all
  end

  def show
    @pickup = Pickup.find(params[:id])
  end

  def new
    @pickup = Pickup.new
  end

  def edit
    
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pickup_params
      params.require(:pickup).permit(:day_id, :donor_title, :donor_first_name, :donor_last_name, :donor_spouse_name, :donor_address_line1, :donor_address_line2, :donor_city, :donor_zip, :donor_dwelling_type, :donor_phone, :donor_email, :number_of_items, :item_notes, :donor_notes, :rejected, :rejected_reason)
    end
end
