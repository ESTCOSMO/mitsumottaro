class Project < ActiveRecord::Base
  attr_accessible :days_per_point, :name, :project_tasks, :template_task_ids
  has_many :categories, dependent: :destroy, order: :position
  has_many :project_tasks, dependent: :destroy, order: :position
  has_many :template_tasks, through: :project_tasks, order: "project_tasks.position"
  accepts_nested_attributes_for :project_tasks, allow_destroy: true
  validates :name, presence: true

  def sum_of_point_50
    categories.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_task_id(project_task_id)
    categories.map{|l| l.sum_of_point_50_by_project_task_id(project_task_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    categories.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def buffer
    Math::sqrt(sum_of_square_of_diff)
  end

  def total_price
    ratio = 1.0 + buffer / sum_of_point_50
    categories.map{|c| c.total_price(ratio, days_per_point)}.inject(0, :+)
  end
end
