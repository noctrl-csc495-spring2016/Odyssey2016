module DaysHelper
  def is_in_past(d)
    if d < Date.today
      return true
    else
      return false
    end
  end
  
  def is_in_this_week(d)
    beginning_of_week = Date.today.at_beginning_of_week - 1
    end_of_week = Date.today.at_end_of_week - 1
    if (d > beginning_of_week) && (d < end_of_week)
      return true 
    else 
      return false 
    end
  end
  
  def is_in_next_week(d)
    beginning_of_week = (Date.today.at_beginning_of_week - 1) + 7
    end_of_week = (Date.today.at_end_of_week - 1) + 7
    if (d > beginning_of_week) && (d < end_of_week)
      return true 
    else 
      return false 
    end
  end
  
  def is_after_next_week(d)
    beginning_of_week = (Date.today.at_beginning_of_week - 1) + 14
    if (d > beginning_of_week)
      return true 
    else 
      return false 
    end
  end
  
end
