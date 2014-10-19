class Allocation < ActiveRecord::Base
  unloadable
  belongs_to :user
  belongs_to :principal, :foreign_key => 'user_id'
  belongs_to :project, :foreign_key => 'project_id'
  
  #validates_uniqueness_of :work_date, :scope => [:project_id,:user_id]
  validates_presence_of :principal, :project
  
  include Redmine::SafeAttributes
  
  safe_attributes 'work_date', 
                  'allocation'
                  
  def self.project_cost(project)
    self.find :all,
              :select => "COUNT(#{Allocation.table_name}.work_date) AS work_date_count, SUM(#{Allocation.table_name}.allocation) AS work_allocation, #{Role.table_name}.name AS role_name",
              :joins => "INNER JOIN #{Role.table_name} ON #{Allocation.table_name}.role_id = #{Role.table_name}.id ",
              :group => "#{Allocation.table_name}.role_id",
              :conditions => "#{Allocation.table_name}.project_id = #{project.id}",
              :order => "#{Role.table_name}.position"
  end
  
end
