class SubjectPoint < ActiveRecord::Base
  attr_accessible :point_50, :point_90, :project_subject_id, :small_item_id
  belongs_to :small_item
  belongs_to :project_subject
  validates :project_subject_id, presence: true
  validates :point_50, numericality: { only_integer: true }
  validates :point_90, numericality: { only_integer: true }

  def square_of_diff
    point_50 && point_90 ? (point_90 - point_50) ** 2 : 0
  end
end
