# -*- coding: utf-8 -*-
require 'spec_helper'

describe ProjectTask do
  describe "field definitions" do
    subject { ProjectTask.new }
    it { should respond_to(:name) }
    it { should respond_to(:position) }
    it { should respond_to(:price_per_day) }
    it { should respond_to(:task_points) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { ProjectTask.new(project_id: 1, template_task_id: 1, name: "試験", position: 1, price_per_day: 40000) }
      it { should be_valid }
    end
    context "when name is not present," do
      subject { ProjectTask.new(name: " ") }
      it{ should_not be_valid }
      it{ should have(1).error_on(:name) }
    end
    context "when price_per_day is not present," do
      subject { ProjectTask.new(price_per_day: " ") }
      it{ should have(1).error_on(:price_per_day) }
    end
    context "when position is not present," do
      subject { ProjectTask.new(position: " ") }
      it{ should_not have(1).error_on(:position) }
    end
  end

  context "when project_task destroy," do
    before do
      @project_task = ProjectTask.new( project_id: 1, template_task_id: 1, name: "試験", position: 1, price_per_day: 40000)
      @project_task.save!
      @task_point = TaskPoint.new( project_task_id: @project_task.id, point_50: 20, point_90: 50 )
      @task_point.save!
    end
    it "project_taskを削除したらtask_pointsも削除されること" do
      TaskPoint.where(project_task_id: @project_task.id).size.should eq 1
      @project_task.destroy!
      TaskPoint.where(project_task_id: @project_task.id).size.should eq 0
    end
  end
end
