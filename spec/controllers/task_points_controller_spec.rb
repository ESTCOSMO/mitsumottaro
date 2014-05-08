require 'spec_helper'

describe TaskPointsController do
  let(:project){ Project.new(name: "Project", days_per_point: 0.5) }
  let(:category){ Category.new(name: "Category") }
  let(:sub_category){ SubCategory.new(name: "Sub") }
  let(:story){ Story.new(name: "Story") }
  let(:project_task){ ProjectTask.create(name: "Sample Task", price_per_day: 50000)}
  let(:task_point){ TaskPoint.new(point_50: 2, point_90: 5, project_task_id: project_task.id)}
  before do
    story.task_points << task_point
    sub_category.stories. << story
    category.sub_categories << sub_category
    project.project_tasks << project_task
    project.categories << category
    project.save!
  end

  describe "POST 'create'" do
    context "when input correct data, " do
      before do
        xhr :post, :create,
             project_id: project.id, category_id: category.id,
             sub_category_id: sub_category.id, story_id: story.id,
             task_point:{ point_50: 5, point_90: 11, project_task_id: project_task.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check saved data count" do
        subject{ TaskPoint.where( project_task_id: project_task.id)}
        its(:size){ should eq 1 }
      end
      describe "check saved data value" do
        subject{ TaskPoint.where( project_task_id: project_task.id).first }
        its(:point_50){ should eq 5 }
        its(:point_90){ should eq 11 }
      end
    end
    context "when point_50 is empty, " do
      before do
        xhr :post, :create,
        project_id: project.id, category_id: category.id,
        sub_category_id: sub_category.id, story_id: story.id,
        task_point:{ point_50: "", point_90: 11, project_task_id: project_task.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
    end
    context "when point_90 is empty, " do
      before do
        xhr :post, :create,
        project_id: project.id, category_id: category.id,
        sub_category_id: sub_category.id, story_id: story.id,
        task_point:{ point_50: 3, point_90: "", project_task_id: project_task.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
    end
  end

  describe "DELETE 'destroy'" do
    context "when input correct data, " do
      before do
        xhr :delete, :destroy,
             project_id: project.id, category_id: category.id,
             sub_category_id: sub_category.id, story_id: story.id,
             id: task_point.id,
             task_point:{ project_task_id: project_task.id }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
      end
      describe "check deleted data" do
        subject{ TaskPoint.where( project_task_id: project_task.id).size }
        it{ should eq 0 }
      end
    end
  end
end
