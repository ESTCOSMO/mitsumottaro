require 'spec_helper'

describe Api::SubCategoriesController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
    @category = @project.categories.create(name: "Category")
  end
  describe "xhr GET 'show':" do
    before do
      @sub_category = @category.sub_categories.create(name: "SampleSubCategory", remarks: "Test", position: 99)
      @story = @sub_category.stories.create(name: "Story")
      @project_task = @project.project_tasks.create(name: "ProjectTask", price_per_day: 40000)
      @task_point = @story.task_points.create(project_task_id: @project_task.id, point_50: 8, point_90: 11)
      xhr :get, :show, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      before{ @sub_category_json = JSON.parse(response.body) }
      subject{ @sub_category_json }
      its(["category_id"]){ should eq @category.id }
      its(["id"]){ should eq @sub_category.id }
      its(["name"]){ should eq @sub_category.name }
      its(["remarks"]){ should eq @sub_category.remarks }
      its(["position"]){ should eq @sub_category.position }
      describe "include stories" do
        before{ @story_json = @sub_category_json["stories"][0] }
        subject{ @story_json }
        its(["sub_category_id"]){ should eq @sub_category.id }
        its(["id"]){ should eq @story.id }
        its(["name"]){ should eq @story.name }
        describe "include task_points" do
          subject{ @story_json["task_points"][0] }
          its(["story_id"]){ should eq @story.id }
          its(["project_task_id"]){ should eq @project_task.id }
          its(["point_50"]){ should eq @task_point.point_50 }
          its(["point_90"]){ should eq @task_point.point_90 }
        end
      end
    end
  end
  describe "xhr POST 'create':" do
    before do
      xhr :post, :create, { project_id: @project.id, category_id: @category.id, name: "SampleNewSubCategory" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["category_id"]){ should eq @category.id }
      its(["id"]){ should_not be_nil }
      its(["name"]){ should eq "SampleNewSubCategory" }
      its(["remarks"]){ should be_nil }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr POST 'update':" do
    before do
      @sub_category = @category.sub_categories.create(name: "SampleSubCategory")
      xhr :post, :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id, name: "UpdateSubCategory", remarks: "Test" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["category_id"]){ should eq @category.id }
      its(["id"]){ should eq @sub_category.id }
      its(["name"]){ should eq "UpdateSubCategory" }
      its(["remarks"]){ should eq "Test" }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr DELETE 'destroy':" do
    before do
      @sub_category = @category.sub_categories.create(name: "SampleSubCategory")
      xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      it{ should be_empty }
    end
    describe "deleted data" do
      subject{ SubCategory.where(id: @sub_category.id).first }
      it{ should be_nil }
    end
  end
  describe "xhr GET 'move_higher':" do
    before do
      @sub_category1 = @category.sub_categories.create(name: "SampleSubCategory1", position: 1)
      @sub_category2 = @category.sub_categories.create(name: "SampleSubCategory2", position: 2)
      @sub_category3 = @category.sub_categories.create(name: "SampleSubCategory3", position: 3)
      xhr :get, :move_higher, { project_id: @project.id, category_id: @category.id, id: @sub_category2.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr GET 'move_lower':" do
    before do
      @sub_category1 = @category.sub_categories.create(name: "SampleSubCategory1", position: 1)
      @sub_category2 = @category.sub_categories.create(name: "SampleSubCategory2", position: 2)
      @sub_category3 = @category.sub_categories.create(name: "SampleSubCategory3", position: 3)
      xhr :get, :move_lower, { project_id: @project.id, category_id: @category.id, id: @sub_category2.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["position"]){ should eq 3 }
    end
  end
end
