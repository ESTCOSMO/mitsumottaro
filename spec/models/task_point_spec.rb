require 'spec_helper'

describe TaskPoint do
  describe "field definitions" do
    subject { TaskPoint.new }
    it { should respond_to(:project_task_id) }
    it { should respond_to(:point_50) }
    it { should respond_to(:point_90) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 50) }
      it { should be_valid }
    end
    context "when project_task_id is not present," do
      subject { TaskPoint.new(project_task_id: " ") }
      it{ should have(1).error_on(:project_task_id) }
    end
    context "when point_50 is not numeric," do
      subject { TaskPoint.new(point_50: "abc") }
      it{ should_not be_valid }
    end
    context "when point_50 is not integer," do
      subject { TaskPoint.new(point_50: 14.5) }
      it{ should_not be_valid }
    end
    context "when point_90 is not numeric," do
      subject { TaskPoint.new(point_90: "abc") }
      it{ should_not be_valid }
    end
    context "when point_90 is not integer," do
      subject { TaskPoint.new(point_90: 8.5) }
      it{ should_not be_valid }
    end
  end

  describe "square_of_diff method" do
    context "both points is not empty," do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ should eq 625 }
    end
    context "point_50 is empty," do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ should eq 0 }
    end
    context "point_90 is empty," do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20) }
      subject { @task_point.square_of_diff }
      it{ should eq 0 }
    end
  end
end
