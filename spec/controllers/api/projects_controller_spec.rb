require 'spec_helper'

describe Api::ProjectsController do
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
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["id"]){ should eq @project.id }
      its(["name"]){ should eq @project.name }
      its(["days_per_point"]){ should eq @project.days_per_point.to_s }
      describe "include project_tasks" do
        subject{ JSON.parse(response.body)["project_tasks"][0] }
        its(["project_id"]){ should eq @project.id }
        its(["id"]){ should eq @project_task.id }
        its(["name"]){ should eq @project_task.name }
        its(["price_per_day"]){ should eq @project_task.price_per_day }
      end
      describe "include additional_costs" do
        subject{ JSON.parse(response.body)["additional_costs"][0] }
        its(["project_id"]){ should eq @project.id }
        its(["id"]){ should eq @additional_cost.id }
        its(["name"]){ should eq @additional_cost.name }
        its(["price"]){ should eq @additional_cost.price }
      end
      describe "include categories" do
        before{ @category_json = JSON.parse(response.body)["categories"][0]}
        subject{ @category_json }
        its(["project_id"]){ should eq @project.id }
        its(["id"]){ should eq @category.id }
        its(["name"]){ should eq @category.name }
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
  end
end
