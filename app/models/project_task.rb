class ProjectTask < ActiveRecord::Base
  belongs_to :project
  belongs_to :template_task
  has_many :task_points, dependent: :destroy
  acts_as_list scope: :project
  validates :name, :price_per_day, presence: true
end
