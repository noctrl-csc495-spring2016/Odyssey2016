class PickupsController < ApplicationController

before_action :logged_in


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
      String error_messages = build_error_message_string(@pickup)
      flash.now[:danger] = error_messages
      render 'new'
    end
end

def reject
    @pickup = Pickup.find(params[:id])
end
#Show the pickup whose id was accessed
def show
    @pickups = Pickup.find(params[:id])
end

#Update a pickup
#Information is submitted when one of the buttons on the edit form is clicked.
#Because the edit form contains five potential buttons (update, schedule, unschedule, reject, send, cancel_email),
#we need five separate cases.
#http://stackoverflow.com/questions/3332449/rails-multi-submit-buttons-in-one-form
def update
    @pickup = Pickup.find(params[:id])
    if params[:update]                                              #Update donor button was clicked
        try_update_pickup(@pickup)
    elsif params[:schedule]                                         #Schedule button was clicked
        try_schedule_pickup(@pickup)
    elsif params[:unschedule]                                       #Unschedule button was clicked
        try_unschedule_pickup(@pickup)
    elsif params[:reject]                                           #Reject button was clicked  
        try_reject_pickup(@pickup)
    elsif params[:send]                                             #Send button was clicked
        @pickup.send_rejection_email
        flash[:success] = "Email has been sent."
        redirect_to '/pickups'
    elsif params[:cancel_email]                                     #Cancel button on email preview was clicked
        flash[:success] = "Pickup has been rejected. Email was not sent."
        redirect_to '/pickups'
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

private

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
    params.require(:pickup).permit(:rejected, :rejected_reason, :send_email, :donor_email)
end


def build_error_message_string(pickup)
    String error_messages = "This form contains errors:<ul>"
    pickup.errors.full_messages.each do |value|
        error_messages += "<li>#{value}</li>"
    end
    error_messages += "</ul>"
    return error_messages
end

def try_update_pickup(pickup)
    @pickup = pickup
    if @pickup.update_attributes(pickup_params)
        flash[:success] = "Pickup information has been updated."
        redirect_to "/pickups"
    else
      String error_messages = build_error_message_string(@pickup)
      flash.now[:danger] = error_messages
      render 'edit'
    end
end

def try_unschedule_pickup(pickup)
    @pickup = pickup
    @pickup.day_id = nil
    if @pickup.update_attributes(pickup_params)
        flash[:success] = "Pickup has been unscheduled."
        redirect_to "/pickups"
    else
        flash.now[:danger] = "Pickup could not be unscheduled."
        render 'edit'
    end    
end

def try_schedule_pickup(pickup)
    @pickup = pickup
    if @pickup.update_attributes(day_and_pickup_params)
            if @pickup.day_id == nil
                @pickup.errors.add(:date,"not valid. Select a day to schedule pickup.")
                String error_messages = build_error_message_string(@pickup)
                flash.now[:danger] = error_messages
                render 'edit'
            else
                flash[:success] = "Pickup has been scheduled."
                redirect_to "/pickups"
            end
    else 
        flash.now[:danger] = "Pickup could not be scheduled."
        render 'edit'
    end
end

def try_reject_pickup(pickup)
    @pickup = pickup
    @pickup.rejected = true                                     #Set rejected to true and update the rejected params
        @pickup.day_id = nil
        if @pickup.update_attributes(rejected_params)
            check_for_missing_email_before_emailing(@pickup)
        else
            flash.now[:danger] = "Pickup could not be rejected."
            render 'edit'
        end
end

def check_for_missing_email_before_emailing(pickup)
    @pickup = pickup
    if @pickup.send_email == true && @pickup.donor_email.blank? == true
        @pickup.errors.add(:donor_email,"address must be present to send rejection email.")
        String error_messages = build_error_message_string(@pickup)
        flash.now[:danger] = error_messages
        render 'edit'
    elsif @pickup.send_email == true && @pickup.donor_email != nil
        render 'reject'
    else
        flash[:success] = "Pickup has been rejected."
        redirect_to "/pickups"
    end
    
end

end
