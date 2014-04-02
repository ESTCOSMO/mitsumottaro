class TemplateTask < ActiveRecord::Base
  acts_as_list
  has_many :project_tasks, -> { order :position }
  validates :name, :price_per_day, presence: true
end
