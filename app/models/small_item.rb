class SmallItem < ActiveRecord::Base
  attr_accessible :medium_item_id, :name, :position
  belongs_to :medium_item
  acts_as_list scope: :medium_item
  has_many :subject_points, dependent: :destroy
  validates :name, presence: true

  def sum_of_point_50
    subject_points.sum(:point_50)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    subject_points.where(project_subject_id: project_subject_id).sum(:point_50)
  end

  def sum_of_square_of_diff
    subject_points.map(&:square_of_diff).inject(0, :+)
  end
end
