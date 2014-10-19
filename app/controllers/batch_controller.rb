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
    #TODO-should consider holidays
    if (date.cwday < 6)
      member_allocations = Member.find :all,
                                       :select => "#{Member.table_name}.*,b.role_id",
                                       :joins => "INNER JOIN (SELECT #{MemberRole.table_name}.member_id, MIN( #{MemberRole.table_name}.role_id ) AS role_id" <<
                                                  " FROM member_roles" <<
                                                  " GROUP BY member_roles.member_id " <<
                                                  " )b ON #{Member.table_name}.id = b.member_id",
                                       :conditions => ["#{Member.table_name}.from_date <= ? AND #{Member.table_name}.to_date >= ?",date,date]
      member_allocations.each do |ma|
        date_allocation = Allocation.where(["allocation > 0 AND work_date = ? AND user_id = ? AND project_id = ?", date, ma.user_id,ma.project_id]).first
        if (date_allocation == nil) 
          date_allocation = Allocation.new
          date_allocation.work_date = date
          date_allocation.user_id = ma.user_id
          date_allocation.project_id = ma.project_id
          date_allocation.role_id = ma.role_id
          date_allocation.allocation = ma.allocation
          date_allocation.save
        end
      end
    end
  end  
  
end
