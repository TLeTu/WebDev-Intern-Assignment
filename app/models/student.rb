class Student < ApplicationRecord
  has_many :subject_scores
  has_many :subjects, through: :subject_scores

  scope :with_sbd, ->(sbd) { find_by(sbd: sbd) }

  scope :top_10_natural_science, lambda {
    joins(subject_scores: :subject)
      .where(subjects: { name: %w[toan vat_li hoa_hoc] })
      .group("students.id")
      .having("COUNT(subject_scores.id) = 3")
      .select("students.*, SUM(subject_scores.score) AS total_score")
      .order("total_score DESC")
      .limit(10)
  }

  def self.count_with_score_in_range(subject_id, min, max)
    joins(:subject_scores)
      .where(subject_scores: { subject_id: subject_id })
      .where("subject_scores.score >= ? AND subject_scores.score < ?", min, max)
      .distinct
      .count
  end

  def score_for(subject_name)
    subject_scores.joins(:subject).find { |ss| ss.subject.name == subject_name }&.score
  end
end
