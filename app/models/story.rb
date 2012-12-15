class Story < ActiveRecord::Base
  attr_accessible :sub_category_id, :name, :position
  belongs_to :sub_category
  acts_as_list scope: :sub_category
  has_many :subject_points, dependent: :destroy
  validates :name, presence: true

  def sum_of_point_50
    subject_points.sum(:point_50)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    subject_points.where(project_subject_id: project_subject_id).sum(:point_50)
  end

  def sum_of_square_of_diff
    subject_points.map(&:square_of_diff).inject(0, :+)
  end

  def total_price(ratio, days_per_point)
    subject_points.map{|sp| sp.point_50 * ratio * days_per_point * sp.project_subject.price_per_day}.inject(0, :+)
  end
end
