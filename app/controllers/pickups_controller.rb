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

#Destroy a pickup (potential feature used by admin)
def destroy
    Pickup.find(params[:id]).destroy
end
#Update a pickup
#Information is submitted when one of the buttons on the edit form is clicked.
#Because the edit and reject forms contain 
#five potential buttons (update, schedule, unschedule, reject, send, cancel_email),
#we need five separate cases.
#http://stackoverflow.com/questions/3332449/rails-multi-submit-buttons-in-one-form
def update
    @pickup = Pickup.find(params[:id])
    if params[:update_donor]                                        #Update donor button was clicked
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

#Method to return a string of errors to be displayed in a flash message
def build_error_message_string(pickup)
    String error_messages = "This form contains errors:<ul>"
    pickup.errors.full_messages.each do |value| #Get all error messages
        error_messages += "<li>#{value}</li>"   #and Add them to string
    end
    error_messages += "</ul>"
    return error_messages                       #Return string
end

#METHODS CALLED BY UPDATE ACTION
#Since rails implements pass by value, all we need to do is pass in the
#pickup as a parameter and its information can be updated.

#Method to try to update pickup information (called by update action)
def try_update_pickup(pickup)
    @pickup = pickup
    if @pickup.update_attributes(pickup_params)
        flash[:success] = "Pickup information has been updated."
        redirect_to "/pickups"
    else
      String error_messages = build_error_message_string(@pickup) #If cannot update, display error messages
      flash.now[:danger] = error_messages
      render 'edit'
    end
end

#Method to try to unschedule a pickup
def try_unschedule_pickup(pickup)
    @pickup = pickup
    if @pickup.update_attributes(pickup_params)
        @pickup.day_id = nil                                #Set day_id to nil and save
        @pickup.save
        flash[:success] = "Pickup has been unscheduled."
        redirect_to "/pickups"
    else                                           
        flash.now[:danger] = "Pickup could not be unscheduled."
        render 'edit'
    end    
end

#Method to try to schedule a pickup
def try_schedule_pickup(pickup)
    @pickup = pickup
    if @pickup.update_attributes(day_and_pickup_params)
        
        #Check if user tries to schedule and schedule spinner is blank
        #If so render error message on edit form that says to select a day.
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

#Method to try to reject a pickup
def try_reject_pickup(pickup)
    @pickup = pickup
    @pickup.rejected = true                                     #Set rejected to true and update the rejected params
    @pickup.day_id = nil
    if @pickup.update_attributes(rejected_params)
        check_for_missing_email_before_emailing(@pickup)        #Cannot send email to an invalid or missing email
    else
        String error_messages = build_error_message_string(@pickup)
        flash.now[:danger] = "Pickup could not be rejected. " + error_messages
        render 'edit'
    end
end

#Method to handle errors if donor tries to email rejection without a valid donor_email present

def check_for_missing_email_before_emailing(pickup)
    @pickup = pickup
    
    #Check if donor has checked box to send email without a valid email present
    if @pickup.send_email == true && @pickup.donor_email.blank? == true
        @pickup.rejected = false;                                                           #Reset rejected fields
        @pickup.rejected_reason = nil;
        @pickup.save
        @pickup.errors.add(:donor_email,"address must be present to send rejection email.") #Display error
        String error_messages = build_error_message_string(@pickup)     
        flash.now[:danger] = error_messages
        render 'edit'
    #If email is present and email donor is checked, send to email preview page.
    elsif @pickup.send_email == true && @pickup.donor_email.blank? == false 
        render 'reject'
        
    #Otherwise leave it rejected and redirect to /pickups
    else
        flash[:success] = "Pickup has been rejected."
        redirect_to "/pickups"
    end
    
end

end
