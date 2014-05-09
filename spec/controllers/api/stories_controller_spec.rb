require 'spec_helper'

describe Api::StoriesController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
    @category = @project.categories.build(name: "Category")
    @sub_category = @category.sub_categories.build(name: "SubCategory")
    @project.save!
  end
  describe "xhr GET 'show':" do
    before do
      @story = @sub_category.stories.build(name: "SampleStory", remarks: "Test", position: 99)
      @sub_category.save!
      xhr :get, :show, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["sub_category_id"]){ should eq @sub_category.id }
      its(["id"]){ should eq @story.id }
      its(["name"]){ should eq @story.name }
      its(["remarks"]){ should eq @story.remarks }
      its(["position"]){ should eq @story.position }
      #TODO check inclides json
    end
  end
  describe "xhr POST 'create':" do
    before do
      xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, name: "SampleNewStory" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["sub_category_id"]){ should eq @sub_category.id }
      its(["id"]){ should_not be_nil }
      its(["name"]){ should eq "SampleNewStory" }
      its(["remarks"]){ should be_nil }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr POST 'update':" do
    before do
      @story = @sub_category.stories.build(name: "SampleStory")
      @sub_category.save!
      xhr :post, :update, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story.id, name: "UpdateStory", remarks: "Test" }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["sub_category_id"]){ should eq @sub_category.id }
      its(["id"]){ should eq @story.id }
      its(["name"]){ should eq "UpdateStory" }
      its(["remarks"]){ should eq "Test" }
      its(["position"]){ should eq 1 }
    end
  end
  describe "xhr DELETE 'destroy':" do
    before do
      @story = @sub_category.stories.build(name: "SampleStory")
      @sub_category.save!
      xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story.id }
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
      subject{ Story.where(id: @story.id).first }
      it{ should be_nil }
    end
  end
  describe "xhr GET 'move_higher':" do
    before do
      @story1 = @sub_category.stories.build(name: "SampleStory1", position: 1)
      @story2 = @sub_category.stories.build(name: "SampleStory2", position: 2)
      @story3 = @sub_category.stories.build(name: "SampleStory3", position: 3)
      @sub_category.save!
      xhr :get, :move_higher, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story2.id }
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
      @story1 = @sub_category.stories.build(name: "SampleStory1", position: 1)
      @story2 = @sub_category.stories.build(name: "SampleStory2", position: 2)
      @story3 = @sub_category.stories.build(name: "SampleStory3", position: 3)
      @sub_category.save!
      xhr :get, :move_lower, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, id: @story2.id }
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
