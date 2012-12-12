class LargeItem < ActiveRecord::Base
  attr_accessible :name, :position, :project_id
  belongs_to :project
  has_many :medium_items, dependent: :destroy
  validates :name, presence: true

  def sum_of_point_50
    mids = medium_items.pluck(:id)
    sids = SmallItem.where(medium_item_id: mids)
    SubjectPoint.where(small_item_id: sids).sum(:point_50)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    mids = medium_items.pluck(:id)
    sids = SmallItem.where(medium_item_id: mids)
    SubjectPoint.where(small_item_id: sids, project_subject_id: project_subject_id).sum(:point_50)
  end

  def count_of_small_items
    medium_items.map(&:count_of_small_items).inject(0) {|result, c| result + c}
  end

  def count_of_medium_items
    medium_items.size
  end
end
