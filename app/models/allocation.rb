class Allocation < ActiveRecord::Base
  unloadable
  belongs_to :user
  belongs_to :principal, :foreign_key => 'user_id'
  belongs_to :project, :foreign_key => 'project_id'
  
  #validates_uniqueness_of :work_date, :scope => [:project_id,:user_id]
  #validates_presence_of :principal, :project
  
  include Redmine::SafeAttributes
  
  safe_attributes 'work_date', 
                  'allocation'
end
