class ItemsController < ApplicationController
  def new
    project = Project.find(params[:project_id])
    large_item_id = params[:large_item_id]
    medium_item_id = params[:medium_item_id]
    if large_item_id.blank?
      @item = project.large_items.build
    elsif medium_item_id.blank?
      @item = project.large_items.find(large_item_id).medium_items.build
    else
      @item = project.large_items.find(large_item_id).medium_items.find(medium_item_id).small_items.build
    end
  end

  def create
    project = Project.find(params[:project_id])
    large_item_id = params[:large_item_id]
    medium_item_id = params[:medium_item_id]

    if large_item_id.blank?
      @item = project.large_items.create!(params[:large_item])
    elsif medium_item_id.blank?
      @item = project.large_items.find(large_item_id).medium_items.create!(params[:medium_item])
    else
      @item = project.large_items.find(large_item_id).medium_items.find(medium_item_id).small_items.create!(params[:small_item])
    end

    redirect_to project_dashboard_path(project.id)
  end
end
