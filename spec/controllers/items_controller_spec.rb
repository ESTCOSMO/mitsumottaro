require 'spec_helper'

describe ItemsController do
  describe "POST 'create':" do
    before do
      @project = Project.create(name: "Project", days_per_point: 1.0 )
    end
    context "case to create category, " do
      context "when input correct data, " do
        before do
          post :create, { project_id: @project.id, category: { name: "SampleCategory", remarks: "Test"} }
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
          post :create, { project_id: @project.id, category: { name: "", remarks: "Test"} }
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
          post :create, { project_id: @project.id, category_id: @category.id,
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
          post :create, { project_id: @project.id, category_id: @category.id,
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
          post :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id,
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
          post :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id,
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
      @project = Project.new(name: "Project", days_per_point: 1.0 )
      @category = @project.categories.build(name: "Category")
      @sub_category = @category.sub_categories.build(name: "SubCategory")
      @story = @sub_category.stories.build(name: "Story")
      @project.save!
    end
    context "case to update category, " do
      context "when input correct data, " do
        before do
          put :update, { project_id: @project.id, id: @category.id,
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
          put :update, { project_id: @project.id, id: @category.id,
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
          put :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id,
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
          put :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id,
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
          put :update, { project_id: @project.id, category_id: @category.id,
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
          put :update, { project_id: @project.id, category_id: @category.id,
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
      @project = Project.new(name: "Project", days_per_point: 1.0 )
      @category = @project.categories.build(name: "Category")
      @sub_category = @category.sub_categories.build(name: "SubCategory")
      @story = @sub_category.stories.build(name: "Story")
      @project.save!
    end
    context "case to destroy category, " do
      before do
        delete :destroy, { project_id: @project.id, id: @category.id }
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
        delete :destroy, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
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
        delete :destroy, { project_id: @project.id, category_id: @category.id,
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
end
