class DaysController < ApplicationController
  include DaysHelper
  before_action :logged_in
  before_action :admin_or_standard
  
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
    #   current year. Also are starting by showing up to @years_to_show years in advance.
    #   Change the number in (#).times in parens to change the number of years
    #   to show.
    @years_to_show = 2
    
    @year_options = []
    (@years_to_show).times do |y|
      @year_options[y] = [(Time.new.year + y).to_s, (Time.new.year + y)]
    end
  end
  
  # Use this action to return all of the days when called from AJAX. Used by 
  #   the calendar only.
  def all
     @days = Day.where("date >= ?", 30.days.ago)
     respond_to do |format|
      format.json { render json: @days }
    end
  end
  
  # Use this action to create an event. Take in params of :month, :day, and :year where the :month comes
  # in as the fully qualified month (i.e. 'January').
  def create
    # Check that the date entered is valid
    # i.e. NOT Feb 31, 2017
    begin
      date = ("#{params[:month]} #{params[:day]} #{params[:year]}").to_date
    rescue ArgumentError
      flash[:danger] = "The date <strong>#{params[:month]} #{params[:day]}, #{params[:year]}</strong> is not valid."
      redirect_to '/days/new'
      return
    end
    
    @day = Day.new(date: date)
    
    # if our query is not empty, we got a day that matched our month, day, and year combo
    #   i.e.: if the day already exists
    if !Day.where("date = ?", @day.date).empty?
      flash[:danger] = "<strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong> is already scheduled as a pickup day."
      redirect_to '/days/new'
      
    # else if the date is in the past
    elsif @day.date < Date.today
      flash[:danger] = "<strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong> is in the past! Please enter a day that is in the future."
      redirect_to '/days/new'
    
    # else the day must be good so we make it
    else
      if @day.save
        flash[:success] = "<strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong> was succesfully added"
        redirect_to '/days'
      else
        flash[:danger] = "<strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong> could not be added"
        redirect_to '/days/new'
      end
    end
  end
  
  # Delete a day only if it has no pickups
  def destroy
    @day = Day.find(params[:id])
    
    if(@day.pickups.any?)
      flash[:danger] = "Cannot remove <strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong>. Please unschedule any pickups for this day first."
    elsif(is_in_past(@day.date))
      flash[:danger] = "Cannot remove <strong>" + @day.date.strftime("%A, %B %d, %Y") + "</strong> because it is in the past."
    else
      @display = @day.date.strftime("%A, %B %d, %Y")
      @day.destroy
      flash[:success] = "Successfully removed <strong>" + @display + "</strong> as a pickup day."
    end
    redirect_to days_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.permit(:month, :day, :year)
    end
end
