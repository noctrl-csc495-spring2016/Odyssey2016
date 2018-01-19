module PickupsHelper

#Method to populate the schedule options for the edit pickup form.
#The options_for_select in f.select is used in dropdown menus to populate the options.
#It takes an array of arrays to populate the options. Therefore this method returns an array of arrays
def populate_day_options
    #Ruby on rails can compare date strings to check if a date
    #came before or after another. In this case we are finding all dates today and in the future.
    #We also order the dates in the scheduler using .order('date ASC') with
    #'ASC'meaning ascending order
    @possibleDays = Day.where("date >= '" + Date.today.to_s + "'").order('date ASC')
    
    #Need an array of arrays to populate options_for_select
    optionsArray = Array.new
    optionsArray.push ["", nil]
    
    #Get each possible day and number of pickups associated with that day
    @possibleDays.each do |d|
        dayOption = ""+ get_day_of_week(d.date)+ " ("     + d.pickups.count.to_s + check_plurality(d.pickups.count) + ")"
        optionsArray.push [dayOption, d.id]  #For each option we must push an array. The first element is the string we want to display, the second is what gets updated in the database when the form is submitted
    end
    return optionsArray
end

#Method to parse the day of the week and date into the desired format.
#The code for strftime and the corresponding % symbols can be viewed here: 
#http://apidock.com/ruby/DateTime/strftime
#Date.parse parses the date_string to date type and strftime then formats the date as desired.
def get_day_of_week(date)
    if (date.blank?)
        return ""
    else
        return date.to_datetime.strftime("%a, %b %d")
    end
end

#Plurality check to see if pickup or pickups should be written next to a date
#in the scheduler
def check_plurality(numberOfPickups)
    if (numberOfPickups == 1)
        return " pickup"
    else
        return " pickups"
    end
end

#Method to populate the state options for the new and edit pickup forms.
def populate_state_options
    return [['AL'],['AK'], ['AZ'], ['AR'], ['CA'], ['CO'], ['CT'], ['DE'], ['DC'], ['FL'], ['GA'], ['HI'], ['ID'],
            ['IL'], ['IN'], ['IA'], ['KS'], ['KY'], ['LA'], ['ME'], ['MD'], ['MA'], ['MI'], ['MN'], ['MS'],
            ['MO'], ['MT'], ['NE'], ['NV'], ['NH'], ['NJ'], ['NM'], ['NY'], ['NC'], ['ND'], ['OH'], ['OK'],
            ['OR'], ['PA'], ['RI'], ['SC'], ['SD'], ['TN'], ['TX'], ['UT'], ['VT'], ['VA'], ['WA'], ['WV'], 
            ['WI'], ['WY']]
end

#Method to populate the title options for the new and edit pickup forms. Added in 1.2.
def populate_title_options
        return [['None'], ['Mr.'], ['Ms.'], ['Mrs.'], ['Dr.'], ['Prof.'], ['Rev.']]
end

#Method to populate the color options for the edit pickups form
def populate_label_colors
    return [["Aqua"],["LightGreen"], ["MediumPurple"], ["Orange"], ["Pink"], ["Red"], ["White"], ["Yellow"]]
end

#Method to build error messages for a pickup
def build_error_message_string(pickup)
    
    String error_messages = "This form contains errors:<ul>"
    pickup.errors.full_messages.each do |key, value| #Get all error messages and return them as string.
        error_messages += "<li>#{key}</li>"
    end
    error_messages += "</ul>"
    return error_messages
end

end
