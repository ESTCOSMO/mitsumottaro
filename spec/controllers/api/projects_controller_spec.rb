require 'spec_helper'

describe Api::ProjectsController, :type => :controller do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
    @project_task = @project.project_tasks.create(name: "ProjectTask", price_per_day: 40000)
    @additional_cost = @project.additional_costs.create(name: "Additional", price: 30000)
    @category = @project.categories.create(name: "Category")
    @sub_category = @category.sub_categories.create(name: "SubCategory")
    @story = @sub_category.stories.create(name: "Story")
    @task_point = @story.task_points.create(project_task_id: @project_task.id, point_50: 8, point_90: 11)
  end
  describe "xhr GET 'show':" do
    before do
      xhr :get, :show, { id: @project.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }

      describe "[\"id\"]" do
        subject { super()["id"] }
        it { is_expected.to eq @project.id }
      end

      describe "[\"name\"]" do
        subject { super()["name"] }
        it { is_expected.to eq @project.name }
      end

      describe "[\"days_per_point\"]" do
        subject { super()["days_per_point"] }
        it { is_expected.to eq @project.days_per_point.to_s }
      end
      describe "include project_tasks" do
        subject{ JSON.parse(response.body)["project_tasks"][0] }

        describe "[\"project_id\"]" do
          subject { super()["project_id"] }
          it { is_expected.to eq @project.id }
        end

        describe "[\"id\"]" do
          subject { super()["id"] }
          it { is_expected.to eq @project_task.id }
        end

        describe "[\"name\"]" do
          subject { super()["name"] }
          it { is_expected.to eq @project_task.name }
        end

        describe "[\"price_per_day\"]" do
          subject { super()["price_per_day"] }
          it { is_expected.to eq @project_task.price_per_day }
        end
      end
      describe "include additional_costs" do
        subject{ JSON.parse(response.body)["additional_costs"][0] }

        describe "[\"project_id\"]" do
          subject { super()["project_id"] }
          it { is_expected.to eq @project.id }
        end

        describe "[\"id\"]" do
          subject { super()["id"] }
          it { is_expected.to eq @additional_cost.id }
        end

        describe "[\"name\"]" do
          subject { super()["name"] }
          it { is_expected.to eq @additional_cost.name }
        end

        describe "[\"price\"]" do
          subject { super()["price"] }
          it { is_expected.to eq @additional_cost.price }
        end
      end
      describe "include categories" do
        before{ @category_json = JSON.parse(response.body)["categories"][0]}
        subject{ @category_json }

        describe "[\"project_id\"]" do
          subject { super()["project_id"] }
          it { is_expected.to eq @project.id }
        end

        describe "[\"id\"]" do
          subject { super()["id"] }
          it { is_expected.to eq @category.id }
        end

        describe "[\"name\"]" do
          subject { super()["name"] }
          it { is_expected.to eq @category.name }
        end
        describe "include sub_categories" do
          before{ @sub_category_json = @category_json["sub_categories"][0]}
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
    end
  end
end
