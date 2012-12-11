class Subject < ActiveRecord::Base
  attr_accessible :name, :position
  has_many :project_subjects, dependent: :destroy
end
