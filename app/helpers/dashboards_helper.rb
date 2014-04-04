# -*- coding: utf-8 -*-
module DashboardsHelper
  def up_arrow_link_to_unless(condition, params={})
    project = params[:project]
    category = params[:category]
    sub_category = params[:sub_category]
    story = params[:story]
    if story.present?
      path = move_higher_project_category_sub_category_story_path(project, category, sub_category, story)
      anchor_name = make_anchor(category.id, sub_category.id, story.id)
    elsif sub_category.present?
      path = move_higher_project_category_sub_category_path(project, category, sub_category)
      anchor_name = make_anchor(category.id, sub_category.id)
    else
      path = move_higher_project_category_path(project, category)
      anchor_name = make_anchor(category.id)
    end
    unless condition
      link_to path, name: anchor_name, class: 'arrow', style: 'color:silver' do
        raw "<i class='icon-arrow-up'></i>"
      end
    end
  end
  def down_arrow_link_to_unless(condition, params={})
    project = params[:project]
    category = params[:category]
    sub_category = params[:sub_category]
    story = params[:story]
    if story.present?
      path = move_lower_project_category_sub_category_story_path(project, category, sub_category, story)
      anchor_name = make_anchor(category.id, sub_category.id, story.id)
    elsif sub_category.present?
      path = move_lower_project_category_sub_category_path(project, category, sub_category)
      anchor_name = make_anchor(category.id, sub_category.id)
    else
      path = move_lower_project_category_path(project, category)
      anchor_name = make_anchor(category.id)
    end
    unless condition
      link_to path, name: anchor_name, class: 'arrow', style: 'color:silver' do
        raw "<i class='icon-arrow-down'></i>"
      end
    end
  end
  def make_anchor(category_id, sub_category_id = nil, story_id = nil)
    if story_id.present?
      "story#{category_id}-#{sub_category_id}-#{story_id}"
    elsif sub_category_id.present?
      "sub_category#{category_id}-#{sub_category_id}"
    else
      "category#{category_id}"
    end
  end
end
