require 'spec_helper'

describe Api::SubCategoriesController, :type => :controller do
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
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      before{ @sub_category_json = JSON.parse(response.body) }
      subject{ @sub_category_json }

      describe "[\"category_id\"]" do
        subject { super()["category_id"] }
        it { is_expected.to eq @category.id }
      end

      describe "[\"id\"]" do
        subject { super()["id"] }
        it { is_expected.to eq @sub_category.id }
      end

      describe "[\"name\"]" do
        subject { super()["name"] }
        it { is_expected.to eq @sub_category.name }
      end

      describe "[\"remarks\"]" do
        subject { super()["remarks"] }
        it { is_expected.to eq @sub_category.remarks }
      end

      describe "[\"position\"]" do
        subject { super()["position"] }
        it { is_expected.to eq @sub_category.position }
      end
      describe "include stories" do
        before{ @story_json = @sub_category_json["stories"][0] }
        subject{ @story_json }

        describe "[\"sub_category_id\"]" do
          subject { super()["sub_category_id"] }
          it { is_expected.to eq @sub_category.id }
        end

        describe "[\"id\"]" do
          subject { super()["id"] }
          it { is_expected.to eq @story.id }
        end

        describe "[\"name\"]" do
          subject { super()["name"] }
          it { is_expected.to eq @story.name }
        end
        describe "include task_points" do
          subject{ @story_json["task_points"][0] }

          describe "[\"story_id\"]" do
            subject { super()["story_id"] }
            it { is_expected.to eq @story.id }
          end

          describe "[\"project_task_id\"]" do
            subject { super()["project_task_id"] }
            it { is_expected.to eq @project_task.id }
          end

          describe "[\"point_50\"]" do
            subject { super()["point_50"] }
            it { is_expected.to eq @task_point.point_50 }
          end

          describe "[\"point_90\"]" do
            subject { super()["point_90"] }
            it { is_expected.to eq @task_point.point_90 }
          end
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
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }

      describe "[\"category_id\"]" do
        subject { super()["category_id"] }
        it { is_expected.to eq @category.id }
      end

      describe "[\"id\"]" do
        subject { super()["id"] }
        it { is_expected.not_to be_nil }
      end

      describe "[\"name\"]" do
        subject { super()["name"] }
        it { is_expected.to eq "SampleNewSubCategory" }
      end

      describe "[\"remarks\"]" do
        subject { super()["remarks"] }
        it { is_expected.to be_nil }
      end

      describe "[\"position\"]" do
        subject { super()["position"] }
        it { is_expected.to eq 1 }
      end
    end
  end
  describe "xhr POST 'update':" do
    before do
      @sub_category = @category.sub_categories.create(name: "SampleSubCategory")
      xhr :post, :update, { project_id: @project.id, category_id: @category.id, id: @sub_category.id, name: "UpdateSubCategory", remarks: "Test" }
    end
    describe "response status" do
      subject{ response.status }
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }

      describe "[\"category_id\"]" do
        subject { super()["category_id"] }
        it { is_expected.to eq @category.id }
      end

      describe "[\"id\"]" do
        subject { super()["id"] }
        it { is_expected.to eq @sub_category.id }
      end

      describe "[\"name\"]" do
        subject { super()["name"] }
        it { is_expected.to eq "UpdateSubCategory" }
      end

      describe "[\"remarks\"]" do
        subject { super()["remarks"] }
        it { is_expected.to eq "Test" }
      end

      describe "[\"position\"]" do
        subject { super()["position"] }
        it { is_expected.to eq 1 }
      end
    end
  end
  describe "xhr DELETE 'destroy':" do
    before do
      @sub_category = @category.sub_categories.create(name: "SampleSubCategory")
      xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id, id: @sub_category.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      it{ is_expected.to be_empty }
    end
    describe "deleted data" do
      subject{ SubCategory.where(id: @sub_category.id).first }
      it{ is_expected.to be_nil }
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
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }

      describe "[\"position\"]" do
        subject { super()["position"] }
        it { is_expected.to eq 1 }
      end
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
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }

      describe "[\"position\"]" do
        subject { super()["position"] }
        it { is_expected.to eq 3 }
      end
    end
  end
end
