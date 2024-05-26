# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_26_032911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "employees_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "employee_id", null: false
    t.index ["employee_id"], name: "index_employees_projects_on_employee_id"
    t.index ["project_id"], name: "index_employees_projects_on_project_id"
  end

  create_table "performers_stages", id: false, force: :cascade do |t|
    t.bigint "stage_id", null: false
    t.bigint "user_id", null: false
    t.index ["stage_id"], name: "index_performers_stages_on_stage_id"
    t.index ["user_id"], name: "index_performers_stages_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "manager_id"
    t.date "start_date"
    t.date "end_date"
    t.text "substances", default: [], array: true
    t.string "pharm_group"
    t.text "analog", default: [], array: true
    t.text "extras", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.boolean "new_preperate"
    t.string "commercial_name"
    t.string "international_no_patent"
    t.string "chemical_name"
    t.string "project_type"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id"
    t.index ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id"
  end

  create_table "stage_tasks", force: :cascade do |t|
    t.bigint "stage_id", null: false
    t.string "name", null: false
    t.text "description"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_stage_tasks_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "project_id", null: false
    t.bigint "predecessor_id"
    t.bigint "successor_id"
    t.string "status", null: false
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.jsonb "attached_files", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["predecessor_id"], name: "index_stages_on_predecessor_id"
    t.index ["project_id"], name: "index_stages_on_project_id"
    t.index ["successor_id"], name: "index_stages_on_successor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "performers_stages", "stages"
  add_foreign_key "performers_stages", "users"
  add_foreign_key "projects", "users", column: "employee_id"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "stage_tasks", "stages"
  add_foreign_key "stages", "projects"
  add_foreign_key "stages", "stages", column: "predecessor_id"
  add_foreign_key "stages", "stages", column: "successor_id"
end
