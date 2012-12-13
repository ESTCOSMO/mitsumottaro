class ProjectSubject < ActiveRecord::Base
  attr_accessible :position, :project_id, :subject_id
  belongs_to :project
  belongs_to :subject
  has_many :subject_points, dependent: :destroy, order: :position
  acts_as_list scope: :project
end
