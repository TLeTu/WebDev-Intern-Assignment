# require 'csv'

# csv_file_path = Rails.root.join('config', 'data', 'diem_thi_thpt_2024.csv')

# # First, create subjects in bulk
# subjects_data = [
#   { name: 'toan', created_at: Time.current, updated_at: Time.current },
#   { name: 'ngu_van', created_at: Time.current, updated_at: Time.current },
#   { name: 'ngoai_ngu', created_at: Time.current, updated_at: Time.current },
#   { name: 'vat_li', created_at: Time.current, updated_at: Time.current },
#   { name: 'hoa_hoc', created_at: Time.current, updated_at: Time.current },
#   { name: 'sinh_hoc', created_at: Time.current, updated_at: Time.current },
#   { name: 'lich_su', created_at: Time.current, updated_at: Time.current },
#   { name: 'dia_li', created_at: Time.current, updated_at: Time.current },
#   { name: 'gdcd', created_at: Time.current, updated_at: Time.current }
# ]

# Subject.insert_all(subjects_data)
# subjects_map = Subject.pluck(:name, :id).to_h

# # Process data in two phases to properly handle foreign keys
# # Phase 1: Import all students first
# student_batch = []
# batch_size = 1000

# CSV.foreach(csv_file_path, headers: true).with_index do |row, index|
#   begin
#     row_data = row.to_hash
#     sbd = row_data['sbd'].to_i
#     ma_ngoai_ngu = row_data['ma_ngoai_ngu']

#     student_batch << {
#       sbd: sbd,
#       ma_ngoai_ngu: ma_ngoai_ngu,
#       created_at: Time.current,
#       updated_at: Time.current
#     }

#     if student_batch.size >= batch_size
#       Student.insert_all(student_batch)
#       student_batch.clear
#       puts "Imported #{index + 1} students..."
#     end
#   rescue StandardError => e
#     puts "Error processing student row #{index + 1}: #{e.message}"
#   end
# end

# # Insert any remaining students
# if student_batch.any?
#   Student.insert_all(student_batch)
#   puts "Imported final batch of #{student_batch.size} students."
# end

# # Phase 2: Now import all scores with proper student_id references
# # Create a map of SBD to student_id for quick lookup
# students_map = Student.pluck(:sbd, :id).to_h

# score_batch = []
# CSV.foreach(csv_file_path, headers: true).with_index do |row, index|
#   begin
#     row_data = row.to_hash
#     sbd = row_data['sbd'].to_i
#     student_id = students_map[sbd]

#     [ 'toan', 'ngu_van', 'ngoai_ngu', 'vat_li', 'hoa_hoc', 'sinh_hoc', 'lich_su', 'dia_li', 'gdcd' ].each do |subject_name|
#       score = row_data[subject_name]
#       next if score.blank?

#       score_batch << {
#         student_id: student_id,
#         subject_id: subjects_map[subject_name],
#         score: score.to_f,
#         created_at: Time.current,
#         updated_at: Time.current
#       }
#     end

#     if score_batch.size >= batch_size * 9 # Approximate since each student has multiple scores
#       SubjectScore.insert_all(score_batch)
#       score_batch.clear
#       puts "Imported scores up to row #{index + 1}..."
#     end
#   rescue StandardError => e
#     puts "Error processing score row #{index + 1}: #{e.message}"
#   end
# end

# # Insert any remaining scores
# if score_batch.any?
#   SubjectScore.insert_all(score_batch)
#   puts "Imported final batch of #{score_batch.size} scores."
# end

# puts "Data import completed successfully."

require 'csv'

csv_file_path = Rails.root.join('config', 'data', 'diem_thi_thpt_2024.csv')

# First, create subjects in bulk
subjects_data = [
  { name: 'toan', created_at: Time.current, updated_at: Time.current },
  { name: 'ngu_van', created_at: Time.current, updated_at: Time.current },
  { name: 'ngoai_ngu', created_at: Time.current, updated_at: Time.current },
  { name: 'vat_li', created_at: Time.current, updated_at: Time.current },
  { name: 'hoa_hoc', created_at: Time.current, updated_at: Time.current },
  { name: 'sinh_hoc', created_at: Time.current, updated_at: Time.current },
  { name: 'lich_su', created_at: Time.current, updated_at: Time.current },
  { name: 'dia_li', created_at: Time.current, updated_at: Time.current },
  { name: 'gdcd', created_at: Time.current, updated_at: Time.current }
]

Subject.insert_all(subjects_data)
subjects_map = Subject.pluck(:name, :id).to_h

# Process data in two phases to properly handle foreign keys
# Phase 1: Import first 1000 students
student_batch = []
batch_size = 1000
row_count = 0

CSV.foreach(csv_file_path, headers: true).with_index do |row, index|
  break if row_count >= 1000 # Stop after 1000 rows

  begin
    row_data = row.to_hash
    sbd = row_data['sbd'].to_i
    ma_ngoai_ngu = row_data['ma_ngoai_ngu']

    student_batch << {
      sbd: sbd,
      ma_ngoai_ngu: ma_ngoai_ngu,
      created_at: Time.current,
      updated_at: Time.current
    }

    row_count += 1

    if student_batch.size >= batch_size || row_count >= 1000
      Student.insert_all(student_batch)
      student_batch.clear
      puts "Imported #{row_count} students..."
    end
  rescue StandardError => e
    puts "Error processing student row #{index + 1}: #{e.message}"
  end
end

# Insert any remaining students
if student_batch.any?
  Student.insert_all(student_batch)
  puts "Imported final batch of #{student_batch.size} students."
end

# Phase 2: Import scores for the first 1000 students
students_map = Student.pluck(:sbd, :id).to_h
score_batch = []
row_count = 0

CSV.foreach(csv_file_path, headers: true).with_index do |row, index|
  break if row_count >= 1000 # Stop after 1000 rows

  begin
    row_data = row.to_hash
    sbd = row_data['sbd'].to_i
    student_id = students_map[sbd]

    [ 'toan', 'ngu_van', 'ngoai_ngu', 'vat_li', 'hoa_hoc', 'sinh_hoc', 'lich_su', 'dia_li', 'gdcd' ].each do |subject_name|
      score = row_data[subject_name]
      next if score.blank?

      score_batch << {
        student_id: student_id,
        subject_id: subjects_map[subject_name],
        score: score.to_f,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    row_count += 1

    if score_batch.size >= batch_size * 9 || row_count >= 1000
      SubjectScore.insert_all(score_batch)
      score_batch.clear
      puts "Imported scores up to row #{row_count}..."
    end
  rescue StandardError => e
    puts "Error processing score row #{index + 1}: #{e.message}"
  end
end

# Insert any remaining scores
if score_batch.any?
  SubjectScore.insert_all(score_batch)
  puts "Imported final batch of #{score_batch.size} scores."
end

puts "Data import completed successfully."
