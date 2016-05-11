class DaysController < ApplicationController

  def index
    @days = Day.all
  end

  def show
    
  end

  def new
    @day = Day.new
  end

  def edit
    
  end

  def create

  end

  def destroy

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.require(:day).permit(:date)
    end
end
