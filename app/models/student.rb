class Student < ApplicationRecord
  has_many :subject_scores
  has_many :subjects, through: :subject_scores
end
