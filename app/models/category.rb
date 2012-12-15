class Category < ActiveRecord::Base
  attr_accessible :name, :position, :project_id
  belongs_to :project
  acts_as_list :scope => :project
  has_many :sub_categories, dependent: :destroy, order: :position
  validates :name, presence: true

  def sum_of_point_50
    sub_categories.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_subject_id(project_subject_id)
    sub_categories.map{|m| m.sum_of_point_50_by_project_subject_id(project_subject_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    sub_categories.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def count_of_stories
    sub_categories.map(&:count_of_stories).inject(0, :+)
  end

  def count_of_sub_categories
    sub_categories.size
  end

  def total_price(ratio, days_per_point)
    sub_categories.map{|sc| sc.total_price(ratio, days_per_point)}.inject(0, :+)
  end
end
