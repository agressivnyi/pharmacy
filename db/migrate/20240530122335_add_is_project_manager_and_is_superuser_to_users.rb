class AddIsProjectManagerAndIsSuperuserToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_project_manager, :boolean
  end
end
