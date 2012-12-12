class Project < ActiveRecord::Base
  attr_accessible :days_per_point, :name, :project_subjects, :subject_ids
  has_many :large_items, dependent: :destroy
  has_many :project_subjects, dependent: :destroy
  has_many :subjects, through: :project_subjects
  accepts_nested_attributes_for :project_subjects, allow_destroy: true
  validates :name, presence: true
end
