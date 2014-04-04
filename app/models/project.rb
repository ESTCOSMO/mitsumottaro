# -*- coding: utf-8 -*-
class Project < ActiveRecord::Base
  has_many :categories, -> { order(:position) }, dependent: :destroy
  has_many :project_tasks, -> { order(:position) }, dependent: :destroy
  has_many :additional_costs, -> { order(:position) }, dependent: :destroy
  has_many :template_tasks,-> { order("project_tasks.position") }, through: :project_tasks
  accepts_nested_attributes_for :project_tasks, allow_destroy: true
  validates :name, presence: true

  def sum_of_point_50
    categories.map(&:sum_of_point_50).inject(0, :+)
  end

  def sum_of_point_50_by_project_task_id(project_task_id)
    categories.map{|l| l.sum_of_point_50_by_project_task_id(project_task_id) }.inject(0, :+)
  end

  def sum_of_square_of_diff
    categories.map(&:sum_of_square_of_diff).inject(0, :+)
  end

  def buffer
    Math::sqrt(sum_of_square_of_diff)
  end

  def total_price_with_buffer
    ratio = 1.0 + buffer / sum_of_point_50
    categories.map{|c| c.total_price(ratio, days_per_point)}.inject(0, :+)
  end

  def total_price_50
    ratio = 1.0
    categories.map{|c| c.total_price(ratio, days_per_point)}.inject(0, :+)
  end

  def dup_deep!
    proj = dup_project!
    dup_additional_costs!(proj)
    project_task_id_map = dup_project_tasks!(proj)
    dup_categories_deep!(proj, project_task_id_map)

    proj
  end

  def dup_project!
    proj = dup
    proj.name += " (コピー)"
    proj.save!
    proj
  end

  def dup_additional_costs!(proj)
    additional_costs.each do |orig_ac|
      proj.additional_costs << orig_ac.dup
    end
    proj.save!
    proj
  end

  def dup_project_tasks!(new_proj)
    project_task_id_map = {}
    project_tasks.each do |orig_pt|
      pt = orig_pt.dup
      pt.project = new_proj
      pt.save!
      project_task_id_map[orig_pt.id] = pt.id
    end
    project_task_id_map
  end

  def dup_categories_deep!(new_proj, project_task_id_map)
    categories.each do |orig_cat|
      new_proj.categories << orig_cat.dup_deep(project_task_id_map)
    end
    new_proj.save!
  end
end
