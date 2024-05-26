class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, null: false
      t.date :start_date
      t.date :end_date
      t.references :stage, null: false, foreign_key: true
      t.references :performer, null: true, foreign_key: { to_table: :users }
      t.references :parent_task, null: true, foreign_key: { to_table: :tasks }
      t.jsonb :attached_files, default: []

      t.timestamps
    end
  end
end
