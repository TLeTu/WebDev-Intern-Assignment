class StudentsController < ApplicationController
  SCORE_RANGES = {
    first_level: { min: 8, max: 10 },
    second_level: { min: 6, max: 8 },
    third_level: { min: 4, max: 6 },
    fourth_level: { min: 0, max: 4 }
  }.freeze
  def index
    @top_10_natural_science = Rails.cache.fetch("top_10_natural_science", expires_in: 1.hour) do
      Student.top_10_natural_science.to_a
    end
  end

  def search
    return unless params[:sbd].present?

    if valid_sbd?(sbd_param)
      @student = Rails.cache.fetch([ "student_sbd", sbd_param ], expires_in: 1.hour) do
        Student.with_sbd(sbd_param)
      end

      flash.now[:error] = "Invalid registration number." unless @student
    else
      flash.now[:error] = "Invalid registration number."
    end
  end


  def statistics
    @subjects = Subject.all.index_by(&:id)

    @score_counts = Rails.cache.fetch("score_statistics", expires_in: 1.hour) do
      SCORE_RANGES.transform_values do |range|
        @subjects.transform_values do |subject|
          Student.count_with_score_in_range(subject.id, range[:min], range[:max])
        end
      end
    end
  end

  def sbd_param
    params.require(:sbd)
  rescue ActionController::ParameterMissing
    nil
  end

  def valid_sbd?(sbd)
    sbd&.match?(/^\d{7,8}$/)
  end
end
