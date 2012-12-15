class ProjectTask < ActiveRecord::Base
  attr_accessible :position, :project_id, :template_task_id, :name, :price_per_day
  belongs_to :project
  belongs_to :template_task
  has_many :task_points, dependent: :destroy
  acts_as_list scope: :project
  validates :name, :price_per_day, presence: true
end
