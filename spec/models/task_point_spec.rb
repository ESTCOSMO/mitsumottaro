require 'spec_helper'

describe TaskPoint do
  before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 50) }
  subject { @task_point }

  it { should respond_to(:project_task_id) }
  it { should respond_to(:point_50) }
  it { should respond_to(:point_90) }

  it { should be_valid }

  describe "when project_task_id is not present" do
    before { @task_point.project_task_id = "" }
    it{ should_not be_valid }
  end

  describe "when point_50 is not numeric" do
    before { @task_point.point_50 = "abc" }
    it{ should_not be_valid }
  end

  describe "when point_50 is not integer" do
    before { @task_point.point_50 = 14.5 }
    it{ should_not be_valid }
  end

  describe "when point_90 is not numeric" do
    before { @task_point.point_90 = "abc" }
    it{ should_not be_valid }
  end

  describe "when point_90 is not integer" do
    before { @task_point.point_90 = 8.5 }
    it{ should_not be_valid }
  end

  describe "square_of_diff method" do
    context "both points is not empty" do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ should eq 625 }
    end
    context "point_50 is empty" do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ should eq 0 }
    end
    context "point_90 is empty" do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20) }
      subject { @task_point.square_of_diff }
      it{ should eq 0 }
    end
  end

  
end
