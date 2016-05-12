class DaysController < ApplicationController
  include DaysHelper
  
  # Use this action to show all the days on schedule1 screen.
  # previously schedule1.html.erb
  def index
    @days = Day.where("date >= ?", 30.days.ago).order('date ASC')
  end
  
  # Use show action to show a day and all of its coresponding scheduled pickups
  # previously schedule3.html.erb
  def show
    @day = Day.find(params[:id])
    @pickups = @day.pickups
  end
  
  # Show the screen to show a new day. This screen has calendar and a form.
  # previously schedule2.html.erb
  def new
    @day = Day.new
    
    # All the month options for our form
    @month_options = [['January', 'January'],['February', 'February'],['March', 'March'],['April', 'April'],
          ['May', 'May'],['June', 'June'],['July', 'July'],['August', 'August'],['September', 'September'],
          ['October', 'October'],['November', 'November'],['December', 'December']]
    
    # All the day options for our form. Always just provide 31 
    #   days because the js will handle filtering which one to show 
    #   based on the month that is selected.
    @day_options = []
    (31).times do |d|
      @day_options[d] = [(d + 1).to_s, (d + 1)]
    end
    
    # All the year options for our form. By default we start with the
    #   current year. Also are starting by showing up to 5 years in advance.
    #   Change the number in (#).times in parens to change the number of years
    #   to show.
    @year_options = []
    (2).times do |y|
      @year_options[y] = [(Time.new.year + y).to_s, (Time.new.year + y)]
    end
  end
  
  # Use this action to return all of the days when called from ajax. Used by 
  #   the calendar only.
  def all
     @days = Day.where("date >= ?", Date.today)
     respond_to do |format|
      format.json { render json: @days }
    end
  end
  
  # Use this action to create a new day from the form on the schedule2 page.
  #   Is a little clunky, will be cleaned up once we decide on if we are going
  #   to store month day and year or just a date.
  # The form passes in (:month, :day, :year) only. :month comes in as a named month
  def create
    date = ("#{params[:month]} #{params[:day]} #{params[:year]}").to_date
    @day = Day.new(date: date)
    
    # if our query is not empty, we got a day that matched our month, day, and year combo
    #   i.e.: if the day already exists
    if !Day.where("date = ?", @day.date).empty?
      flash[:danger] = "That day is already configured as a pickup day"
      redirect_to '/days/new'
      
    # else if the date is in the past
    elsif @day.date < Date.today
      flash[:danger] = "The day you entered is in the past! Please enter a day that is in the future."
      redirect_to '/days/new'
    
    # else the day must be good so we make it
    else
      if @day.save
        flash[:success] = "The day was succesfully added"
        redirect_to '/days'
      else
        flash[:danger] = "Day could not be added"
        redirect_to '/days/new'
      end
    end
  end
  
  # Delete a day only if it has no pickups
  def destroy
    @day = Day.find(params[:id])
    
    if(@day.pickups.any?)
      flash[:danger] = "Cannot remove day. Please unschedule any pickups for this day first."
    elsif(is_in_past(@day.date))
      flash[:danger] = "Cannot remove day because it is in the past."
    else
      @day.destroy
      flash[:success] = "Successfully removed day"
    end
    redirect_to days_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.permit(:month, :day, :year)
    end
end
