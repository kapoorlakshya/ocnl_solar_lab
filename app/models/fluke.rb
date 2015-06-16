class Fluke < ActiveRecord::Base

  def self.search(start_date, end_date) 

    if start_date && end_date

      start_date = ( Time.parse start_date ).beginning_of_day
      end_date = ( Time.parse end_date ).end_of_day

      where(log_time: start_date..end_date)  
    
    else  
      nil
    end 
     
  end  

end
