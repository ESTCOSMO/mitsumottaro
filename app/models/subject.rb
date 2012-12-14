class Subject < ActiveRecord::Base
  attr_accessible :name, :position, :price_per_day
  acts_as_list
  has_many :project_subjects, order: :position
  validates :name, presence: true
end
