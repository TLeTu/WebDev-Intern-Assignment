class SubjectScore < ApplicationRecord
  belongs_to :student, touch: true
  belongs_to :subject
end
