# -*- coding: utf-8 -*-
class ItemsController < ApplicationController
  before_filter :set_project_to_variable

  def create
    category_id = params[:category_id]
    sub_category_id = params[:sub_category_id]

    if category_id.blank?
      @project.categories.create!(permitted_params_of_category)
    elsif sub_category_id.blank?
      @project.categories.find(category_id).sub_categories.create!(permitted_params_of_sub_category)
    else
      @project.categories.find(category_id).sub_categories.find(sub_category_id).stories.create!(permitted_params_of_story)
    end
    render nothing: true, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def update
    item = find_item_from_params

    category_id = params[:category_id]
    sub_category_id = params[:sub_category_id]
    if category_id.blank?
      item.update_attributes!(permitted_params_of_category)
    elsif sub_category_id.blank?
      item.update_attributes!(permitted_params_of_sub_category)
    else
      item.update_attributes!(permitted_params_of_story)
    end
    render nothing: true, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def destroy
    find_item_from_params.destroy
    render nothing: true, status: :ok
  end

  def move_higher
    item = find_item_from_params
    item.move_higher

    redirect_to project_dashboard_path(@project, anchor: make_anchor_from_params)
  end

  def move_lower
    item = find_item_from_params
    item.move_lower

    redirect_to project_dashboard_path(@project, anchor: make_anchor_from_params)
  end

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

  def make_anchor_from_params
    category_id = params[:category_id]
    sub_category_id = params[:sub_category_id]
    if category_id.blank?
      view_context.make_anchor(params[:id])
    elsif sub_category_id.blank?
      view_context.make_anchor(category_id, params[:id])
    else
      view_context.make_anchor(category_id, sub_category_id, params[:id])
    end
  end

  def permitted_params_of_category
    params.require(:category).permit(:name, :remarks)
  end

  def permitted_params_of_sub_category
    params.require(:sub_category).permit(:name, :remarks)
  end

  def permitted_params_of_story
    params.require(:story).permit(:name, :remarks)
  end
end
