# -*- coding: utf-8 -*-
require 'spec_helper'

describe Story do
  describe "field definitions" do
    subject { Story.new }
    it { should respond_to(:name) }
    it { should respond_to(:position) }
    it { should respond_to(:remarks) }
    it { should respond_to(:task_points) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { Story.new(sub_category_id: 1, name: "Story", position: 1, remarks: "備考") }
      it { should be_valid }
    end
    context "when name is not present," do
      subject { Story.new(name: "") }
      it{ should have(1).error_on(:name) }
    end
  end

  context "when story destroy," do
    before do
      @story = Story.new( sub_category_id: 1, name: "Story", position: 1, remarks: "備考")
      @story.task_points.build( project_task_id: 1, point_50: 20, point_90: 50 )
      @story.save!
    end
    subject { @story }
    it "storyを削除したらtask_pointsも削除されること" do
      TaskPoint.where(story_id: @story.id).size.should eq 1
      @story.destroy!
      TaskPoint.where(story_id: @story.id).size.should eq 0
    end
  end

  describe "sum of point" do
    let(:project_task1){ ProjectTask.create(name:"要件定義", price_per_day: 50000) }
    let(:project_task2){ ProjectTask.create(name:"設計", price_per_day: 40000) }
    let(:project_task3){ ProjectTask.create(name:"試験", price_per_day: 45000) }
    before do
      @story = Story.new( sub_category_id: 1, name: "Story", position: 1, remarks: "備考")
      @story.task_points.build( project_task_id: project_task1.id, point_50: 10, point_90: 40 )
      @story.task_points.build( project_task_id: project_task1.id, point_50: 20, point_90: 45 )
      @story.task_points.build( project_task_id: project_task2.id, point_50: 30, point_90: 50 )
      @story.task_points.build( project_task_id: project_task3.id, point_50: 40, point_90: 60 )
      @story.save!
    end
    describe "sum_of_point_50 method" do
      subject{ @story.sum_of_point_50 }
      it{ should eq 100 }
    end
    describe "sum_of_point_50_by_project_task_id method" do
      subject{ @story.sum_of_point_50_by_project_task_id(1) }
      it{ should eq 30 }
    end
    describe "sum_of_square_of_diff method" do
      subject{ @story.sum_of_square_of_diff }
      it{ should eq 2325 }
    end
    describe "total_price method" do
      subject{ @story.total_price(1.2, 0.5) }
      it{ should eq 2700000 }
    end
  end

  describe "dup_deep method: " do
    let(:org_story) do
      story = Story.new(name: "Story1")
      story.task_points.build(project_task_id: 1, point_50: 3, point_90: 5)
      story.task_points.build(project_task_id: 2, point_50: 5, point_90: 8)
      story
    end
    before do
      @project_task_id_map = { 1 => 11, 2 => 12 }
      @new_story = org_story.dup_deep(@project_task_id_map)
    end
    context "check story value, " do
      subject{ @new_story }
      its(:name){ should eq "Story1" }
    end
    context "check task_points counts, " do
      subject { @new_story.task_points }
      it{ should have(2).items }
    end
    context "check task_points values, " do
      specify do
        @new_story.task_points.each_with_index do |tp, i|
          org_tp = org_story.task_points[i]
          tp.project_task_id.should eq @project_task_id_map[org_tp.project_task_id]
          tp.point_50.should eq org_tp.point_50
          tp.point_90.should eq org_tp.point_90
        end
      end
    end
  end
end
