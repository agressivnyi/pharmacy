class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :manager_id
      t.integer :employee_id
      t.date :start_date
      t.date :end_date
      t.text :substances, array: true, default: []
      t.string :pharm_group
      t.text :analog, array: true, default: []
      t.text :extras, array: true, default: []

      t.timestamps
    end

    add_foreign_key :projects, :users, column: :manager_id
    add_foreign_key :projects, :users, column: :employee_id
  end
end
