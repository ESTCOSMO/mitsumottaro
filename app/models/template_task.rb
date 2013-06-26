class TemplateTask < ActiveRecord::Base
  attr_accessible :name, :position, :price_per_day
  acts_as_list
  has_many :project_tasks, order: :position
  validates :name, :price_per_day, presence: true
end
