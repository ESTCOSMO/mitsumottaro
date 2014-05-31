# -*- coding: utf-8 -*-
require 'spec_helper'

describe ItemsController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
  end
  describe "POST 'copy':" do
    before do
      @project_task = @project.project_tasks.create(name: "ProjectTask", price_per_day: 40000)
      @category1 = @project.categories.build(name: "Category1")
      @category2 = @project.categories.build(name: "Category2")
      @sub_category1 = @category1.sub_categories.build(name: "SubCategory1")
      @sub_category2 = @category2.sub_categories.build(name: "SubCategory2")
      @story1 = @sub_category1.stories.build(name: "Story1")
      @story2 = @sub_category2.stories.build(name: "Story2")
      @task_point1 = @story1.task_points.build(point_50: 1, point_90: 3, project_task_id: @project_task.id)
      @task_point2 = @story2.task_points.build(point_50: 5, point_90: 8, project_task_id: @project_task.id)
      @project.save!
    end
    context "case of invalid params, " do
      before do
        xhr :post, :copy, { project_id: @project.id, id: @category1.id, dst_item_form: { type: 'category', name: '' }}
      end
      describe "response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
      describe "check the data is not" do
        subject{ Project.find(@project.id).categories.size }
        it { should eq 2 }
      end
    end
    context "case to copy category, " do
      before do
        xhr :post, :copy, { project_id: @project.id, id: @category1.id, dst_item_form: { type: 'category', name: 'Category-copied' }}
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check the data is copied" do
        subject{ Project.find(@project.id).categories.size }
        it { should eq 3 }
      end
      describe "check the copied data is correct" do
        before{ @copied_category = Category.where(project_id: @project.id).order(:id).last }
        specify do
          @copied_category.name = 'Category-copied'
          @copied_category.sub_categories.each do |sub_category|
            sub_category.name = @sub_category1.name
            sub_category.stories.each do |story|
              story.name = @story1.name
              story.task_points.each do |points|
                points.point_50 = @task_point1.point_50
                points.point_90 = @task_point1.point_90
              end
            end
          end
        end
      end
    end
    context "case to copy sub_category, " do
      before do
        xhr :post, :copy, { project_id: @project.id, category_id: @category1.id, id: @sub_category1.id, dst_item_form: { type: 'sub_category', category_id: @category2.id, name: 'SubCategory-copied' } }
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check the data is copied" do
        subject{ Category.find(@category2.id).sub_categories.size }
        it { should eq 2 }
      end
      describe "check the copied data is correct" do
        before{ @copied_sub_category = SubCategory.where(category_id: @category2.id).order(:id).last }
        specify do
          @copied_sub_category.name = 'SubCategory-copied'
          @copied_sub_category.stories.each do |story|
            story.name = @story1.name
            story.task_points.each do |points|
              points.point_50 = @task_point1.point_50
              points.point_90 = @task_point1.point_90
            end
          end
        end
      end
    end
    context "case to copy story, " do
      before do
        xhr :post, :copy, { project_id: @project.id, category_id: @category1.id, sub_category_id: @sub_category1.id, id: @story1.id, dst_item_form: { type: 'story', category_id: @category2.id, sub_category_id: @sub_category2.id, name: 'Story-copied' } }
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check the data is copied" do
        subject{ SubCategory.find(@sub_category2.id).stories.size }
        it { should eq 2 }
      end
      describe "check the copied data is correct" do
        before{ @copied_story = Story.where(sub_category_id: @sub_category2.id).order(:id).last }
        specify do
          @copied_story.name = 'Story-copied'
          @copied_story.task_points.each do |points|
            points.point_50 = @task_point1.point_50
            points.point_90 = @task_point1.point_90
          end
        end
      end
    end
  end
end
