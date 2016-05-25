#Controller for all Pickup pages
class PickupsController < ApplicationController

before_action :logged_in

#NOTE ON REDIRECT_TO VS RENDER:
#Render tells the controller to render a view without passing any data. We use this for when we must re-render
#forms such as when an a user submits a form with invalid or missing data.For example if a user 
#is on a new pickup form and tries to add a pickup with missing information, a 
#redirect_to pickups/new would cause the user to lose all fields he or she already filled out. 
#A render, by default remembers those fields and since the controller is not involved
#those fields stay filled out.
#For more information: 
#http://stackoverflow.com/questions/17236122/what-is-the-difference-between-link-to-redirect-to-and-render



#Bullpen page.
#Display all pickups where the day_id is null and the rejected flag is false
def index
    @pickups = Pickup.where({day_id: nil, rejected: false})
end


#Method to create a new pickup.
#Accessed on POST from new form.
def create
  @pickup = Pickup.new(pickup_params)                    #Pass pickup attributes from form into new pickup
    if @pickup.save                                      #Saves if required fields were filled in.
      flash[:success] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> has been added."
      redirect_to "/pickups"                             
    else
      String error_messages = build_error_message_string(@pickup)
      flash.now[:danger] = error_messages
      render 'new'
    end
end

#Reject page. Reject pickup whose id was accessed.
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
        flash[:success] = "Email has been sent to <strong>" + @pickup.donor_last_name + "</strong>."
        redirect_to '/pickups'
    elsif params[:cancel_email]                                     #Cancel button on email preview was clicked
        flash[:success] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> has been rejected. Email was not sent."
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

#PRIVATE METHODS
private

#Permit the donor/pickup information to be updated if the update donor button is clicked
def pickup_params
    params.require(:pickup).permit(:donor_title, :donor_first_name, :donor_last_name, :donor_email, :donor_address_line1, :donor_address_line2,
    :donor_phone, :donor_city, :donor_state, :donor_zip, :donor_dwelling_type, :item_notes, :donor_notes, :number_of_items)
end

#Permit the donor/pickup information and schedule information to be updated if schedule
#button is clicked
def day_and_pickup_params
    params.require(:pickup).permit(:donor_title, :donor_last_name, :donor_first_name, :donor_email, :donor_address_line1, :donor_address_line2,
    :donor_phone, :donor_city, :donor_state, :donor_zip, :donor_dwelling_type, :item_notes, :donor_notes, :number_of_items, :day_id)
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
        #Pickup has been successfully updated
        #Redirect to proper page.
        #Edit form was accessed from the home index.
        if @pickup.day_id == nil
            flash[:success] = "Pickup information for <strong>" + @pickup.donor_last_name + "</strong> has been updated."
            redirect_to "/pickups"
        #Edit form was accessed from a schedule page.
        else
            flash[:success] = "Pickup information <strong>" + @pickup.donor_last_name + "</strong> has been updated."
            redirect_to "/days/" + @pickup.day_id.to_s               
        end
    #Could not update attributes. Display error.
    else
      String error_messages = build_error_message_string(@pickup) #If cannot update, display error messages
      flash.now[:danger] = error_messages
      render 'edit'
    end
end

#Method to try to unschedule a pickup
def try_unschedule_pickup(pickup)
    @pickup = pickup
    #Update the pickup with attributes from the form and remove day from pickup
    if @pickup.update_attributes(pickup_params)
        @pickup.day_id = nil                                
        @pickup.save
        flash[:success] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> has been unscheduled."
        redirect_to "/pickups"
    else                                           
        flash.now[:danger] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> could not be unscheduled."
        render 'edit'
    end    
end

#Method to try to schedule a pickup
#Updates the pickup attributes from form and sets the pickup's day_id
#to match the selected day.
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
            flash[:success] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> has been scheduled."
            redirect_to "/pickups"
        end
    #Could not update attributes. Display error.
    else 
        flash.now[:danger] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> could not be scheduled."
        render 'edit'
    end
end

#Method to try to reject a pickup
def try_reject_pickup(pickup)
    @pickup = pickup
    @dayID = @pickup.day_id
    #Update pickup parameters for rejected pickup.
    @pickup.rejected = true
    @pickup.day_id = nil
    #Make sure rejected reason is there, otherwise add that as error
    if @pickup.update_attributes(rejected_params)
            #Since rejected fields are not required, we must manually check
            #for missing rejected fields if a user tries to reject a pickup
            check_for_missing_rejected_fields(@pickup, @dayID)
    else
        #If could not update the pickups attributes print out error message
        String error_messages = build_error_message_string(@pickup)
        flash.now[:danger] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> could not be rejected. " + error_messages
        render 'edit'
    end
end

#Method to handle errors if donor tries to email rejection without a valid donor_email present
def check_for_missing_rejected_fields(pickup, dayID)
    @pickup = pickup
    @dayID = dayID
    @somethingMissing = false;
    #Check for missing email if user has checked send email
    if @pickup.send_email == true && @pickup.donor_email.blank? == true
        @somethingMissing = true
        @pickup.errors.add(:donor_email,"address must be present to send rejection email.")
    end
    #Check for missing rejected reason
    if @pickup.rejected_reason.blank?
        @somethingMissing = true
        @pickup.errors.add(:rejected_reason,"is missing.")
    end
    #If there is a problem, re-render the form with error messages
    if @somethingMissing == true
        String error_messages = build_error_message_string(@pickup)     
        flash.now[:danger] = error_messages
        
        #Give the pickup back the day before re-rendering the edit form
        #This is so the unschedule button remains
        @pickup.day_id = dayID
        @pickup.save
        render 'edit'
        
        
        #In order to show the previously placed in fields for rejected, we must leave
        #them in the database to render the form. We can then reset the rejected fields
        #after the form has been rendered. This is so when a user checks the 
        #email box without an email present, it will still show the rejected
        #reason if it is there. Since render is not a redirect, the line of code below will
        #execute.
        reset_reject_params(@pickup)
    #Send to preview page if all is filled in 
    elsif @pickup.send_email == true && @pickup.donor_email.blank? == false && !@pickup.rejected_reason.blank? 
        render 'reject'
    #Otherwise leave it rejected and redirect to /pickups
    else
        flash[:success] = "Pickup for <strong>" + @pickup.donor_last_name + "</strong> has been rejected."
        redirect_to "/pickups"
    end
end

#Method reset all reject fields for a pickup.
#This method is only called if rejected fields are missing
#when a user presses reject.
def reset_reject_params(pickup)
    @pickup = pickup
    @pickup.rejected = false                            #Reset rejected fields
    @pickup.rejected_reason = nil
    @pickup.send_email = false
    @pickup.save
end


end
