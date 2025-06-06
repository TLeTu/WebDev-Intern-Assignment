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

ActiveRecord::Schema[8.0].define(version: 2025_06_05_223550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "students", force: :cascade do |t|
    t.bigint "sbd", null: false
    t.string "ma_ngoai_ngu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sbd"], name: "index_students_on_sbd", unique: true
  end

  create_table "subject_scores", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "subject_id", null: false
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_subject_scores_on_student_id"
    t.index ["subject_id"], name: "index_subject_scores_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "subject_scores", "students"
  add_foreign_key "subject_scores", "subjects"
end
