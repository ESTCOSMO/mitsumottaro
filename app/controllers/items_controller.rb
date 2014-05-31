# -*- coding: utf-8 -*-
class ItemsController < ApplicationController
  before_filter :set_project_to_variable

  def copy
    item = find_item_from_params
    copy_item = item.dup_deep(@project.org_project_task_id_map)

    category_id = params[:category_id]
    sub_category_id = params[:sub_category_id]
    dst_params = DstItemForm.new(params[:dst_item_form])
    copy_item.name = dst_params.name
    copy_item.position = nil
    if dst_params.valid?
      dst_category_id = dst_params.category_id
      dst_sub_category_id = dst_params.sub_category_id
      if category_id.blank?
        @project.categories << copy_item
      elsif sub_category_id.blank?
        @project.categories.find(dst_category_id).sub_categories << copy_item
      else
        @project.categories.find(dst_category_id).sub_categories.find(dst_sub_category_id).stories << copy_item
      end
      @project.save!
      render nothing: true, status: :ok
    else
      render json: dst_params.errors.full_messages, status: :bad_request
    end
  end

  private

  def set_project_to_variable
    @project = Project.find(params[:project_id])
  end

  def find_item_from_params
    category_id = params[:category_id]
    sub_category_id = params[:sub_category_id]

    if category_id.blank?
      @project.categories.find(params[:id])
    elsif sub_category_id.blank?
      @project.categories.find(category_id).sub_categories.find(params[:id])
    else
      @project.categories.find(category_id).sub_categories.find(sub_category_id).stories.find(params[:id])
    end
  end
end
