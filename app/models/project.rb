class Project < ActiveRecord::Base
  attr_accessible :days_per_point, :name, :project_subjects, :subject_ids
  has_many :large_items, dependent: :destroy, order: :position
  has_many :project_subjects, dependent: :destroy, order: :position
  has_many :subjects, through: :project_subjects, order: "project_subjects.position"
  accepts_nested_attributes_for :project_subjects, allow_destroy: true
  validates :name, presence: true

  def sum_of_point_50
    large_items.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    large_items.map{|l| l.sum_of_point_50_by_project_subject_id(project_subject_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    large_items.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def buffer
    Math::sqrt(sum_of_square_of_diff) / 2
  end

  def total_price
    ratio = 1.0 + buffer / sum_of_point_50
    large_items.map{|item| item.total_price(ratio, days_per_point)}.inject(0, :+)
  end
end
