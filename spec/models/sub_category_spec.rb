# -*- coding: utf-8 -*-
require 'spec_helper'

describe SubCategory do
  describe "field definitions" do
    subject { SubCategory.new }
    it { should respond_to(:name) }
    it { should respond_to(:position) }
    it { should respond_to(:remarks) }
    it { should respond_to(:stories) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { SubCategory.new(category_id: 1, name: "SubCategory", position: 1, remarks: "備考") }
      it { should be_valid }
    end
    context "when name is not present," do
      subject { SubCategory.new(name: "") }
      it{ should have(1).error_on(:name) }
    end
    context "when position is not present," do
      subject { SubCategory.new(position: " ") }
      it{ should_not have(1).error_on(:position) }
    end
    context "when remarks is not present," do
      subject { SubCategory.new(remarks: " ") }
      it{ should_not have(1).error_on(:remarks) }
    end
  end

  context "when sub_category destroy," do
    before do
      @sub_category = SubCategory.new(category_id: 1, name: "SubCategory")
      @sub_category.stories.build(name: "Story")
      @sub_category.save!
    end
    subject{ @sub_category }
    it "sub_categoryを削除したらstoryも削除されること" do
      Story.where(sub_category_id: @sub_category.id).size.should eq 1
      @sub_category.destroy!
      Story.where(sub_category_id: @sub_category.id).size.should eq 0
    end
  end

  describe "count_of_stories" do
    context "when having no stories," do
      before { @sub_category = SubCategory.new(category_id: 1, name: "SubCategory") }
      subject{ @sub_category.count_of_stories }
      it{ should eq 0 }
    end
    context "when having some stories," do
      before do
        @sub_category = SubCategory.new(category_id: 1, name: "SubCategory")
        @sub_category.stories.build(name: "Story1")
        @sub_category.stories.build(name: "Story2")
      end
      subject{ @sub_category.count_of_stories }
      it{ should eq 2 }
    end
  end

  describe "sum_of_point" do
    let(:project_task1){ ProjectTask.create(name:"要件定義", price_per_day: 50000) }
    let(:project_task2){ ProjectTask.create(name:"設計", price_per_day: 40000) }
    let(:project_task3){ ProjectTask.create(name:"試験", price_per_day: 45000) }
    let(:project_task4){ ProjectTask.create(name:"マニュアル", price_per_day: 30000) }
    let(:project_task5){ ProjectTask.create(name:"導入", price_per_day: 55000) }
    let(:story1) do
      story = Story.new(name: "Story1")
      story.task_points.build(project_task_id: project_task1.id, point_50: 3, point_90: 5)
      story.task_points.build(project_task_id: project_task1.id, point_50: 5, point_90: 8)
      story.task_points.build(project_task_id: project_task2.id, point_50: 8, point_90: 13)
      story.task_points.build(project_task_id: project_task3.id, point_50: 2, point_90: 5)
      story
    end
    let(:story2) do
      story = Story.new(name: "Story2")
      story.task_points.build(project_task_id: project_task1.id, point_50: 1, point_90: 2)
      story.task_points.build(project_task_id: project_task4.id, point_50: 2, point_90: 3)
      story.task_points.build(project_task_id: project_task4.id, point_50: 8, point_90: 13)
      story.task_points.build(project_task_id: project_task5.id, point_50: 5, point_90: 8)
      story
    end
    before do
      @sub_category = SubCategory.new(category_id: 1, name: "Sub1")
      @sub_category.stories << story1
      @sub_category.stories << story2
      @sub_category.save!
    end

    describe "sum_of_point_50 method" do
      subject{ @sub_category.sum_of_point_50 }
      it{ should eq 34 }
    end
    describe "sum_of_point_50_by_project_task_id method" do
      subject{ @sub_category.sum_of_point_50_by_project_task_id(1) }
      it{ should eq 9 }
    end
    describe "sum_of_square_of_diff method" do
      subject{ @sub_category.sum_of_square_of_diff }
      it{ should eq 83 }
    end
    describe "total_price method" do
      subject{ @sub_category.total_price(1.5, 0.5) }
      it{ should eq 1076250 }
    end
  end

  describe "dup_deep method: " do
    let(:story1) do
      story = Story.new(name: "Story1")
      story.task_points.build(project_task_id: 1, point_50: 3, point_90: 5)
      story.task_points.build(project_task_id: 2, point_50: 5, point_90: 8)
      story
    end
    let(:story2) do
      story = Story.new(name: "Story2")
      story.task_points.build(project_task_id: 1, point_50: 1, point_90: 2)
      story
    end
    let(:org_sub_category) do
      sub_category = SubCategory.new(name: "SubCategory1")
      sub_category.stories << story1
      sub_category.stories << story2
      sub_category
    end
    before do
      @project_task_id_map = { 1 => 11, 2 => 12 }
      @new_sub_category = org_sub_category.dup_deep(@project_task_id_map)
    end
    context "check sub_category value, " do
      subject{ @new_sub_category }
      its(:name){ should eq "SubCategory1" }
    end
    context "check stories counts, " do
      subject { @new_sub_category.stories }
      it{ should have(2).items }
    end
    context "check stories values, " do
      specify do
        @new_sub_category.stories.each_with_index do |story, i|
          org_story = org_sub_category.stories[i]
          story.name.should eq org_story.name
          story.task_points.each_with_index do |tp, j|
            org_tp = org_story.task_points[j]
            tp.project_task_id.should eq @project_task_id_map[org_tp.project_task_id]
            tp.point_50.should eq org_tp.point_50
            tp.point_90.should eq org_tp.point_90
          end
        end
      end
    end
  end
end
