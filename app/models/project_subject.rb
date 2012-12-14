class ProjectSubject < ActiveRecord::Base
  attr_accessible :position, :project_id, :subject_id, :name, :price_per_day
  belongs_to :project
  belongs_to :subject
  has_many :subject_points, dependent: :destroy
  acts_as_list scope: :project
  validates :name, :price_per_day, presence: true
end
