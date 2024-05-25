class CreateJoinTableProjectsEmployees < ActiveRecord::Migration[7.0]
  def change
    create_join_table :projects, :employees do |t|
      t.index :project_id
      t.index :employee_id
    end
  end
end
