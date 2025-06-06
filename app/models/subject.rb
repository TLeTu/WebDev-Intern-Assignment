class Subject < ApplicationRecord
  has_many :subject_scores
  has_many :students, through: :subject_scores

  SUBJECT_DISPLAY_NAMES = {
    "toan" => "Toán",
    "ngu_van" => "Ngữ văn",
    "ngoai_ngu" => "Ngoại ngữ",
    "vat_li" => "Vật lí",
    "hoa_hoc" => "Hóa học",
    "sinh_hoc" => "Sinh học",
    "lich_su" => "Lịch sử",
    "dia_li" => "Địa lí",
    "gdcd" => "GDCD"
  }.freeze

  def display_name
    SUBJECT_DISPLAY_NAMES[name] || name.humanize
  end
end
