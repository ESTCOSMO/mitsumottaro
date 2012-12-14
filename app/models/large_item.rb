class LargeItem < ActiveRecord::Base
  attr_accessible :name, :position, :project_id
  belongs_to :project
  acts_as_list :scope => :project
  has_many :medium_items, dependent: :destroy, order: :position
  validates :name, presence: true

  def sum_of_point_50
    medium_items.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    medium_items.map{|m| m.sum_of_point_50_by_project_subject_id(project_subject_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    medium_items.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def count_of_small_items
    medium_items.map(&:count_of_small_items).inject(0, :+)
  end

  def count_of_medium_items
    medium_items.size
  end
end
