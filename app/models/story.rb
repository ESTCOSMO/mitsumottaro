class Story < ActiveRecord::Base
  attr_accessible :sub_category_id, :name, :position
  belongs_to :sub_category
  acts_as_list scope: :sub_category
  has_many :task_points, dependent: :destroy
  validates :name, presence: true

  def sum_of_point_50
    task_points.sum(:point_50)
  end

  def sum_of_point_50_by_project_task_id(project_task_id)
    task_points.where(project_task_id: project_task_id).sum(:point_50)
  end

  def sum_of_square_of_diff
    task_points.map(&:square_of_diff).inject(0, :+)
  end

  def total_price(ratio, days_per_point)
    task_points.map{|sp| sp.point_50 * ratio * days_per_point * sp.project_task.price_per_day}.inject(0, :+)
  end
end
