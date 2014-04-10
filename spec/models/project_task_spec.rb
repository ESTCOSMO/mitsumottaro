# -*- coding: utf-8 -*-
require 'spec_helper'

describe ProjectTask do
  before { @project_task = ProjectTask.new }
  subject { @project_task }

  it { should respond_to(:name) }
  it { should respond_to(:position) }
  it { should respond_to(:price_per_day) }
  it { should respond_to(:task_points) }

  describe "validation" do
    before { @project_task = ProjectTask.new( project_id: 1, template_task_id: 1, name: "試験", position: 1, price_per_day: 40000) }
    subject { @project_task }
    it { should be_valid }

    context "when name is not present," do
      before { @project_task.name = "" }
      it{ should_not be_valid }
    end

    context "when price_per_day is not present," do
      before { @project_task.price_per_day = "" }
      it{ should_not be_valid }
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
