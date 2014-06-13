# -*- coding: utf-8 -*-
require 'spec_helper'

describe ProjectTask, :type => :model do
  describe "field definitions" do
    subject { ProjectTask.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:price_per_day) }
    it { is_expected.to respond_to(:task_points) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { ProjectTask.new(project_id: 1, template_task_id: 1, name: "試験", position: 1, price_per_day: 40000) }
      it { is_expected.to be_valid }
    end
    context "when name is not present," do
      subject { ProjectTask.new(name: " ").tap(&:valid?) }
      it{ is_expected.not_to be_valid }
      it'has 1 error_on' do
        expect(subject.errors[:name].size).to eq(1)
      end
    end
    context "when price_per_day is not present," do
      subject { ProjectTask.new(price_per_day: " ").tap(&:valid?) }
      it'has 1 error_on' do
        expect(subject.errors[:price_per_day].size).to eq(1)
      end
    end
    context "when position is not present," do
      subject { ProjectTask.new(position: " ").tap(&:valid?) }
      it'does not have 1 error_on' do
        expect(subject.errors[:position].size).not_to eq(1)
      end
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
      expect(TaskPoint.where(project_task_id: @project_task.id).size).to eq 1
      @project_task.destroy!
      expect(TaskPoint.where(project_task_id: @project_task.id).size).to eq 0
    end
  end
end
