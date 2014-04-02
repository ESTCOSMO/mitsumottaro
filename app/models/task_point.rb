class TaskPoint < ActiveRecord::Base
  belongs_to :story
  belongs_to :project_task
  validates :project_task_id, presence: true
  validates :point_50, numericality: { only_integer: true }
  validates :point_90, numericality: { only_integer: true }

  def square_of_diff
    point_50 && point_90 ? (point_90 - point_50) ** 2 : 0
  end
end
