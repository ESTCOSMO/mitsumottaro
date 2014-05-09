require 'spec_helper'

describe Api::CategoriesController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
  end
  describe "xhr GET 'show':" do
    before do
      @category = @project.categories.create(name: "SampleCategory", remarks: "Test", position: 99)
      @sub_category = @category.sub_categories.create(name: "SubCategory")
      @story = @sub_category.stories.create(name: "Story")
      @project_task = @project.project_tasks.create(name: "ProjectTask", price_per_day: 40000)
      @task_point = @story.task_points.create(project_task_id: @project_task.id, point_50: 8, point_90: 11)
      xhr :get, :show, { project_id: @project.id, id: @category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      before{ @category_json = JSON.parse(response.body) }
      subject{ @category_json }
      its(["project_id"]){ should eq @project.id }
      its(["id"]){ should eq @category.id }
      its(["name"]){ should eq @category.name }
      its(["remarks"]){ should eq @category.remarks }
      its(["position"]){ should eq @category.position }
      describe "include sub_categories" do
        before{ @sub_category_json = @category_json["sub_categories"][0]}
        subject{ @sub_category_json }
        its(["category_id"]){ should eq @category.id }
        its(["id"]){ should eq @sub_category.id }
        its(["name"]){ should eq @sub_category.name }
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
  end
  describe "xhr POST 'create':" do
    before do
      xhr :post, :create, { project_id: @project.id, name: "SampleNewCategory" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["project_id"]){ should eq @project.id }
      its(["id"]){ should_not be_nil }
      its(["name"]){ should eq "SampleNewCategory" }
      its(["remarks"]){ should be_nil }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr POST 'update':" do
    before do
      @category = @project.categories.create(name: "SampleCategory")
      xhr :post, :update, { project_id: @project.id, id: @category.id, name: "UpdateCategory", remarks: "Test" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["project_id"]){ should eq @project.id }
      its(["id"]){ should eq @category.id }
      its(["name"]){ should eq "UpdateCategory" }
      its(["remarks"]){ should eq "Test" }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr DELETE 'destroy':" do
    before do
      @category = @project.categories.create(name: "SampleCategory")
      xhr :delete, :destroy, { project_id: @project.id, id: @category.id }
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
      subject{ Category.where(id: @category.id).first }
      it{ should be_nil }
    end
  end
  describe "xhr GET 'move_higher':" do
    before do
      @category1 = @project.categories.create(name: "Category1", position: 1)
      @category2 = @project.categories.create(name: "Category2", position: 2)
      @category3 = @project.categories.create(name: "Category3", position: 3)
      xhr :get, :move_higher, { project_id: @project.id, id: @category2.id }
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
      @category1 = @project.categories.create(name: "Category1", position: 1)
      @category2 = @project.categories.create(name: "Category2", position: 2)
      @category3 = @project.categories.create(name: "Category3", position: 3)
      xhr :get, :move_lower, { project_id: @project.id, id: @category2.id }
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
