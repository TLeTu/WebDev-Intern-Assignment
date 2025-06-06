class CreateSubjectScores < ActiveRecord::Migration[8.0]
  def change
    create_table :subject_scores do |t|
      t.references :student, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.float :score

      t.timestamps
    end
  end
end
