# -*- coding: utf-8 -*-
require 'spec_helper'

describe ItemsController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
  end
  describe "xhr POST 'create':" do
    context "case to create category, " do
      context "when input correct data, " do
        before do
          xhr :post, :create, { project_id: @project.id, category: { name: "SampleCategory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ Category.where(project_id: @project.id).first }
          its(:name){ should eq "SampleCategory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :post, :create, { project_id: @project.id, category: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
    context "case to create sub_category, " do
      before do
        @category = @project.categories.build(name: "Category")
        @project.save!
      end
      context "when input correct data, " do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id,
                          sub_category: { name: "SampleSubCategory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ SubCategory.where(category_id: @category.id).first }
          its(:name){ should eq "SampleSubCategory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id,
                          sub_category: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
    context "case to create story, " do
      before do
        @category = @project.categories.build(name: "Category")
        @sub_category = @category.sub_categories.build(name: "SubCategory")
        @project.save!
      end
      context "when input correct data, " do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id,
                          story: { name: "SampleStory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ Story.where(sub_category_id: @sub_category.id).first }
          its(:name){ should eq "SampleStory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id,
                          story: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
  end
  describe "PUT 'update':" do
    before do
      @category = @project.categories.build(name: "Category")
      @sub_category = @category.sub_categories.build(name: "SubCategory")
      @story = @sub_category.stories.build(name: "Story")
      @project.save!
    end
    context "case to update category, " do
      context "when input correct data, " do
        before do
          xhr :put, :update, { project_id: @project.id, id: @category.id,
                         category: { name: "UpdateCategory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ Category.where(project_id: @project.id).first }
          its(:name){ should eq "UpdateCategory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :put, :update, { project_id: @project.id, id: @category.id,
                         category: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
    context "case to update sub_category, " do
      context "when input correct data, " do
        before do
          xhr :put, :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id,
                         sub_category: { name: "UpdateSubCategory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ SubCategory.where(category_id: @category.id).first }
          its(:name){ should eq "UpdateSubCategory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :put, :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id,
                         sub_category: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
    context "case to update story, " do
      context "when input correct data, " do
        before do
          xhr :put, :update, { project_id: @project.id, category_id: @category.id,
                         sub_category_id: @sub_category.id, id: @story.id,
                         story: { name: "UpdateStory", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe "check saved data" do
          subject{ Story.where(sub_category_id: @sub_category.id).first }
          its(:name){ should eq "UpdateStory" }
          its(:remarks){ should eq "Test" }
        end
      end
      context "when name is empty, " do
        before do
          xhr :put, :update, { project_id: @project.id, category_id: @category.id,
                         sub_category_id: @sub_category.id, id: @story.id,
                         story: { name: "", remarks: "Test"} }
        end
        describe "check response status" do
          subject{ response.status }
          it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
  end
  describe "DELETE 'destroy':" do
    before do
      @category = @project.categories.build(name: "Category")
      @sub_category = @category.sub_categories.build(name: "SubCategory")
      @story = @sub_category.stories.build(name: "Story")
      @project.save!
    end
    context "case to destroy category, " do
      before do
        xhr :delete, :destroy, { project_id: @project.id, id: @category.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check deleted data" do
        subject{ Category.where(project_id: @project.id).size }
        it { should eq 0 }
      end
    end
    context "case to destroy sub_category, " do
      before do
        xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check deleted data" do
        subject{ SubCategory.where(category_id: @category.id).size }
        it { should eq 0 }
      end
    end
    context "case to destroy story, " do
      before do
        xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id,
                           sub_category_id: @sub_category.id, id: @story.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check deleted data" do
        subject{ Story.where(sub_category_id: @sub_category.id).size }
        it { should eq 0 }
      end
    end
  end
  describe "GET 'move_higher':" do
    context "case to move_higher category, " do
      before do
        @category1 = @project.categories.build(name: "Category1", position: 1)
        @category2 = @project.categories.build(name: "Category2", position: 2)
        @category3 = @project.categories.build(name: "Category3", position: 3)
        @project.save!
        get :move_higher, { project_id: @project.id, id: @category2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "category#{@category2.id}") }
      end
      describe "check items order" do
        before{ @categories = Category.where(project_id: @project.id).order(:position) }
        specify do
          @categories[0].should eq @category2
          @categories[1].should eq @category1
          @categories[2].should eq @category3
        end
      end
    end
    context "case to move_higher sub_category, " do
      before do
        @category = @project.categories.build(name: "Category")
        @sub_category1 = @category.sub_categories.build(name: "SubCategory1", position: 1)
        @sub_category2 = @category.sub_categories.build(name: "SubCategory2", position: 2)
        @sub_category3 = @category.sub_categories.build(name: "SubCategory3", position: 3)
        @project.save!
        get :move_higher, { project_id: @project.id, category_id: @category.id, id: @sub_category2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "sub_category#{@category.id}-#{@sub_category2.id}") }
      end
      describe "check items order" do
        before{ @sub_categories = SubCategory.where(category_id: @category.id).order(:position) }
        specify do
          @sub_categories[0].should eq @sub_category2
          @sub_categories[1].should eq @sub_category1
          @sub_categories[2].should eq @sub_category3
        end
      end
    end
    context "case to move_higher story, " do
      before do
        @category = @project.categories.build(name: "Category")
        @sub_category = @category.sub_categories.build(name: "SubCategory")
        @story1 = @sub_category.stories.build(name: "Story1", position: 1)
        @story2 = @sub_category.stories.build(name: "Story2", position: 2)
        @story3 = @sub_category.stories.build(name: "Story3", position: 3)
        @project.save!
        get :move_higher, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "story#{@category.id}-#{@sub_category.id}-#{@story2.id}") }
      end
      describe "check items order" do
        before{ @stories = Story.where(sub_category_id: @sub_category.id).order(:position) }
        specify do
          @stories[0].should eq @story2
          @stories[1].should eq @story1
          @stories[2].should eq @story3
        end
      end
    end
  end

  describe "GET 'move_lower':" do
    context "case to move_lower category, " do
      before do
        @category1 = @project.categories.build(name: "Category1", position: 1)
        @category2 = @project.categories.build(name: "Category2", position: 2)
        @category3 = @project.categories.build(name: "Category3", position: 3)
        @project.save!
        get :move_lower, { project_id: @project.id, id: @category2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "category#{@category2.id}") }
      end
      describe "check items order" do
        before{ @categories = Category.where(project_id: @project.id).order(:position) }
        specify do
          @categories[0].should eq @category1
          @categories[1].should eq @category3
          @categories[2].should eq @category2
        end
      end
    end
    context "case to move_lower sub_category, " do
      before do
        @category = @project.categories.build(name: "Category")
        @sub_category1 = @category.sub_categories.build(name: "SubCategory1", position: 1)
        @sub_category2 = @category.sub_categories.build(name: "SubCategory2", position: 2)
        @sub_category3 = @category.sub_categories.build(name: "SubCategory3", position: 3)
        @project.save!
        get :move_lower, { project_id: @project.id, category_id: @category.id, id: @sub_category2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "sub_category#{@category.id}-#{@sub_category2.id}") }
      end
      describe "check items order" do
        before{ @sub_categories = SubCategory.where(category_id: @category.id).order(:position) }
        specify do
          @sub_categories[0].should eq @sub_category1
          @sub_categories[1].should eq @sub_category3
          @sub_categories[2].should eq @sub_category2
        end
      end
    end
    context "case to move_lower story, " do
      before do
        @category = @project.categories.build(name: "Category")
        @sub_category = @category.sub_categories.build(name: "SubCategory")
        @story1 = @sub_category.stories.build(name: "Story1", position: 1)
        @story2 = @sub_category.stories.build(name: "Story2", position: 2)
        @story3 = @sub_category.stories.build(name: "Story3", position: 3)
        @project.save!
        get :move_lower, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story2.id }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_dashboard_path(@project, anchor: "story#{@category.id}-#{@sub_category.id}-#{@story2.id}") }
      end
      describe "check items order" do
        before{ @stories = Story.where(sub_category_id: @sub_category.id).order(:position) }
        specify do
          @stories[0].should eq @story1
          @stories[1].should eq @story3
          @stories[2].should eq @story2
        end
      end
    end
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
