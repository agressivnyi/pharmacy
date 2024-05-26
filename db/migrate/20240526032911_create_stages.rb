class CreateStages < ActiveRecord::Migration[7.0]
  def change
    create_table :stages do |t|
      t.string :name, null: false
      t.references :project, null: false, foreign_key: true
      t.references :predecessor, foreign_key: { to_table: :stages }
      t.references :successor, foreign_key: { to_table: :stages }
      t.string :status, null: false
      t.date :start_date
      t.date :end_date
      t.text :description
      t.jsonb :attached_files, default: []
      t.timestamps
    end

    create_table :stage_tasks do |t|
      t.references :stage, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.date :due_date
      t.timestamps
    end

    create_table :performers_stages, id: false do |t|
      t.references :stage, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
