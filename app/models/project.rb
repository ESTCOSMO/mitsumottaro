class Project < ActiveRecord::Base
  attr_accessible :days_per_point, :name
  has_many :large_items, dependent: :destroy
  has_many :project_subjects, dependent: :destroy
end
