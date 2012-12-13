class MediumItem < ActiveRecord::Base
  attr_accessible :large_item_id, :name, :position
  belongs_to :large_item
  acts_as_list scope: :large_item
  has_many :small_items, dependent: :destroy, order: :position
  validates :name, presence: true

  def count_of_small_items
    small_items.size
  end

  def sum_of_point_50
    small_items.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    small_items.map{|s| s.sum_of_point_50_by_project_subject_id(project_subject_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    small_items.map(&:sum_of_square_of_diff).inject(0, :+)
  end
end
