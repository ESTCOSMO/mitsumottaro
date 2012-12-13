class Subject < ActiveRecord::Base
  attr_accessible :name, :position
  acts_as_list
  has_many :project_subjects, dependent: :destroy, order: :position
end
