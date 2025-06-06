class Subject < ApplicationRecord
  has_many :subject_scores
  has_many :students, through: :subject_scores
end
