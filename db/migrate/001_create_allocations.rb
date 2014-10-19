class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :role_id
      t.date :work_date
      t.integer :allocation, :null => false, :default => 0
    end
  end
end
