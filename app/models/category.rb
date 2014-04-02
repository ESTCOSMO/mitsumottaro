class Category < ActiveRecord::Base
  belongs_to :project
  acts_as_list :scope => :project
  has_many :sub_categories, -> { order(:position) }, dependent: :destroy
  validates :name, presence: true

  def sum_of_point_50
    sub_categories.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_task_id(project_task_id)
    sub_categories.map{|m| m.sum_of_point_50_by_project_task_id(project_task_id) }.inject(0, :+)
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

  def dup_deep(project_task_id_map)
    cat = dup
    sub_categories.each do |sub_cat|
      cat.sub_categories << sub_cat.dup_deep(project_task_id_map)
    end
    cat
  end
end
