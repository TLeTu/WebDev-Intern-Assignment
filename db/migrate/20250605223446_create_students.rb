class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.bigint :sbd, null: false
      t.string :ma_ngoai_ngu

      t.timestamps
    end
    add_index :students, :sbd, unique: true
  end
end
