class SubCategory < ActiveRecord::Base
  attr_accessible :category_id, :name, :position, :remarks
  belongs_to :category
  acts_as_list scope: :category
  has_many :stories, dependent: :destroy, order: :position
  validates :name, presence: true

  def count_of_stories
    stories.size
  end

  def sum_of_point_50
    stories.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_task_id(project_task_id)
    stories.map{|s| s.sum_of_point_50_by_project_task_id(project_task_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    stories.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def total_price(ratio, days_per_point)
    stories.map{|m| m.total_price(ratio, days_per_point)}.inject(0, :+)
  end
end
