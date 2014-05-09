require 'spec_helper'

describe Api::CategoriesController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
  end
  describe "xhr GET 'show':" do
    before do
      @category = @project.categories.build(name: "SampleCategory", remarks: "Test", position: 99)
      @project.save!
      xhr :get, :show, { project_id: @project.id, id: @category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["project_id"]){ should eq @project.id }
      its(["id"]){ should eq @category.id }
      its(["name"]){ should eq @category.name }
      its(["remarks"]){ should eq @category.remarks }
      its(["position"]){ should eq @category.position }
      # TODO check includes json
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
      @category = @project.categories.build(name: "SampleCategory")
      @project.save!
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
      @category = @project.categories.build(name: "SampleCategory")
      @project.save!
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
      @category1 = @project.categories.build(name: "Category1", position: 1)
      @category2 = @project.categories.build(name: "Category2", position: 2)
      @category3 = @project.categories.build(name: "Category3", position: 3)
      @project.save!
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
      @category1 = @project.categories.build(name: "Category1", position: 1)
      @category2 = @project.categories.build(name: "Category2", position: 2)
      @category3 = @project.categories.build(name: "Category3", position: 3)
      @project.save!
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
