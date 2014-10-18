class BatchController < ApplicationController
  unloadable
  
  skip_before_filter :check_if_login_required, :only => [:allocation]
  
  #record user allocation daily
  def allocation
    date_str = params[:date] || Date.today.strftime("%Y-%m-%d")
    from_date = Date.strptime(date_str, "%Y-%m-%d")
    today = Date.today
    if (from_date > today) 
      from_date = today
    end
    (from_date..today).each do |date|
      update_date(date)
    end
    
    render(:layout=>false)
  end
  
private
  #save work allocation of 1 day
  def update_date(date)
    member_allocations = Member.where(["from_date <= ? AND to_date >= ?", date, date]).all
    member_allocations.each do |ma|
      date_allocation = Allocation.where(["work_date = ? AND user_id = ? AND project_id = ?", date, ma.user_id,ma.project_id]).first
      if (date_allocation == nil) 
        date_allocation = Allocation.new
        date_allocation.work_date = date
        date_allocation.user_id = ma.user_id
        date_allocation.project_id = ma.project_id
        date_allocation.allocation = ma.allocation
        date_allocation.save
      end
    end
  end  
  
end
