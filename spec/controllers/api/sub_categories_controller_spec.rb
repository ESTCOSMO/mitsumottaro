require 'spec_helper'

describe Api::SubCategoriesController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
    @category = @project.categories.build(name: "Category")
    @project.save!
  end
  describe "xhr GET 'show':" do
    before do
      @sub_category = @category.sub_categories.build(name: "SampleSubCategory", remarks: "Test", position: 99)
      @category.save!
      xhr :get, :show, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["category_id"]){ should eq @category.id }
      its(["id"]){ should eq @sub_category.id }
      its(["name"]){ should eq @sub_category.name }
      its(["remarks"]){ should eq @sub_category.remarks }
      its(["position"]){ should eq @sub_category.position }
      #TODO check inclides json
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
      #TODO check inclides json
    end
  end
  describe "xhr POST 'update':" do
    before do
      @sub_category = @category.sub_categories.build(name: "SampleSubCategory")
      @category.save!
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
      @sub_category = @category.sub_categories.build(name: "SampleSubCategory")
      @category.save!
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
  end
  describe "xhr GET 'move_higher':" do
    before do
      @sub_category1 = @category.sub_categories.build(name: "SampleSubCategory1", position: 1)
      @sub_category2 = @category.sub_categories.build(name: "SampleSubCategory2", position: 2)
      @sub_category3 = @category.sub_categories.build(name: "SampleSubCategory3", position: 3)
      @category.save!
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
      @sub_category1 = @category.sub_categories.build(name: "SampleSubCategory1", position: 1)
      @sub_category2 = @category.sub_categories.build(name: "SampleSubCategory2", position: 2)
      @sub_category3 = @category.sub_categories.build(name: "SampleSubCategory3", position: 3)
      @category.save!
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
