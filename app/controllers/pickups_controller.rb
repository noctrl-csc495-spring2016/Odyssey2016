class PickupsController < ApplicationController

before_action :logged_in
before_action :admin_or_standard, except: [:show,:index,:new,:create]

#Bullpen page.
#Display all pickups where the day_id is null and the rejected flag is false
def index
    @pickups = Pickup.where({day_id: nil, rejected: false})
end


#Create a new Pickup
def create
  @pickup = Pickup.new(pickup_params)                    #Pass pickup params from form into new pickup
    if @pickup.save                                      #Saves if required fields were filled in.
        flash[:success] = "Pickup has been added."
        redirect_to "/pickups"
    else
        flash.now[:danger] = "Required fields were left blank."
        render 'new'
    end
end


#Show the pickup whose id was accessed
def show
    @pickups = Pickup.find(params[:id])
end

#Update a pickup
#Information is submitted when one of the buttons on the edit form is clicked.
#Because the edit form contains five potential buttons (update donor, schedule, reschedule, reject, and cancel),
#we need five separate cases.
#http://stackoverflow.com/questions/3332449/rails-multi-submit-buttons-in-one-form
def update
    @pickup = Pickup.find(params[:id])
    if params[:update]                                              #Update donor button was clicked
        if @pickup.update_attributes(pickup_params)
            flash[:success] = "Pickup information has been updated."
            redirect_to "/pickups"
        else
            flash.now[:danger] = "Required fields were left blank."
            render 'edit'
        end
    elsif params[:schedule]                                         #Schedule button was clicked
        if @pickup.update_attributes(day_and_pickup_params)
            flash[:success] = "Pickup has been scheduled."
            redirect_to "/pickups"
        else 
            flash.now[:danger] = "Pickup could not be scheduled."
            render 'edit'
        end
    elsif params[:unschedule]                                        #Reschedule button was clicked
        @pickup.day_id = nil
        if @pickup.update_attributes(pickup_params)
            flash[:success] = "Pickup has been unscheduled."
            redirect_to "/pickups"
        else
            flash.now[:danger] = "Pickup could not be unscheduled."
            render 'edit'
        end    
    elsif params[:reject]                                           
        @pickup.rejected = true                                     #Set rejected to true and update the rejected params
        @pickup.day_id = nil
        if @pickup.update_attributes(rejected_params)
            flash[:success] = "Pickup has been rejected."
            redirect_to "/pickups"
        else
            flash.now[:danger] = "Pickup could not be rejected."
            render 'edit'
        end
    end
end

#Define a new Pickup
def new
    @pickup = Pickup.new
end

#Edit a pickup
#Set the pickup fields on the edit page to the pickup whose id was accessed
def edit
    @pickup = Pickup.find(params[:id])
end

def show
    @pickup = Pickup.find(params[:id])
end

#Permit the donor/pickup information to be updated if the update donor button is clicked
def pickup_params
    params.require(:pickup).permit(:donor_title, :donor_first_name, :donor_last_name, :donor_email, :donor_address_line1, :donor_address_line2,
    :donor_phone, :donor_city, :donor_state, :donor_zip, :donor_dwelling_type, :item_notes, :donor_notes, :number_of_items)
end

#Permit the donor/pickup information and schedule information to be updated if schedule
#button is clicked
def day_and_pickup_params
    params.require(:pickup).permit(:donor_name, :donor_first_name, :donor_email, :donor_address_line1, :donor_address_line2,
    :donor_phone, :donor_city, :donor_state, :donor_zip, :donor_dwelling_type, :other_notes, :item_description, :number_of_items, :day_id)
end

#Permit the rejected fields to be updated in database if reject button is clicked
def rejected_params
    params.require(:pickup).permit(:rejected, :rejected_reason)
end


end
