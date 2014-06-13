# -*- coding: utf-8 -*-
require 'spec_helper'

describe Category, :type => :model do
  describe "field definitions" do
    subject { Category.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:remarks) }
    it { is_expected.to respond_to(:sub_categories) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { Category.new(project_id: 1, name: "Category", position: 1, remarks: "備考") }
      it { is_expected.to be_valid }
    end
    context "when name is not present," do
      subject { Category.new(name: "").tap(&:valid?) }
      it'has 1 error_on' do
        expect(subject.errors[:name].size).to eq(1)
      end
    end
    context "when position is not present," do
      subject { Category.new(position: " ").tap(&:valid?) }
      it'does not have 1 error_on' do
        expect(subject.errors[:position].size).not_to eq(1)
      end
    end
    context "when remarks is not present," do
      subject { Category.new(remarks: " ").tap(&:valid?) }
      it'does not have 1 error_on' do
        expect(subject.errors[:remarks].size).not_to eq(1)
      end
    end
  end

  context "when category destroy," do
    before do
      @category = Category.new(project_id: 1, name: "Category")
      @category.sub_categories.build(name: "SubCategory")
      @category.save!
    end
    subject{ @category }
    it "categoryを削除したらstoryも削除されること" do
      expect(SubCategory.where(category_id: @category.id).size).to eq 1
      @category.destroy!
      expect(SubCategory.where(category_id: @category.id).size).to eq 0
    end
  end

  describe "count_of_sub_categories" do
    context "when having no sub_categories," do
      before { @category = Category.new(project_id: 1, name: "Category") }
      subject{ @category.count_of_sub_categories }
      it{ is_expected.to eq 0 }
    end
    context "when having some sub_categories," do
      before do
        @category = Category.new(project_id: 1, name: "Category")
        @category.sub_categories.build(name: "SubCategory1")
        @category.sub_categories.build(name: "SubCategory2")
      end
      subject{ @category.count_of_sub_categories }
      it{ is_expected.to eq 2 }
    end
  end

  describe "count_of_sub_stories" do
    let(:sub_category1) do
      sub_category = SubCategory.new(name: "SubCategory1")
      sub_category.stories.build(name: "Story1")
      sub_category.stories.build(name: "Story2")
      sub_category
    end
    let(:sub_category2) do
      sub_category = SubCategory.new(name: "SubCategory2")
      sub_category.stories.build(name: "Story1")
      sub_category.stories.build(name: "Story2")
      sub_category.stories.build(name: "Story3")
      sub_category
    end
    context "when having no stories," do
      before { @category = Category.new(project_id: 1, name: "Category") }
      subject{ @category.count_of_stories }
      it{ is_expected.to eq 0 }
    end
    context "when having some stories," do
      before do
        @category = Category.new(project_id: 1, name: "Category")
        @category.sub_categories << sub_category1
        @category.sub_categories << sub_category2
      end
      subject{ @category.count_of_stories }
      it{ is_expected.to eq 5 }
    end
  end

  describe "sum_of_point" do
    let(:project_task1){ FactoryGirl.create(:project_task1, price_per_day: 50000) }
    let(:project_task2){ FactoryGirl.create(:project_task2, price_per_day: 40000) }
    let(:project_task3){ FactoryGirl.create(:project_task3, price_per_day: 45000) }
    let(:project_task4){ FactoryGirl.create(:project_task4, price_per_day: 30000) }
    let(:project_task5){ FactoryGirl.create(:project_task5, price_per_day: 55000) }
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
      story.task_points.build(project_task_id: project_task3.id, point_50: 2, point_90: 3)
      story.task_points.build(project_task_id: project_task4.id, point_50: 8, point_90: 13)
      story.task_points.build(project_task_id: project_task5.id, point_50: 5, point_90: 8)
      story
    end
    let(:story3) do
      story = Story.new(name: "Story3")
      story.task_points.build(project_task_id: project_task3.id, point_50: 3, point_90: 5)
      story.task_points.build(project_task_id: project_task3.id, point_50: 5, point_90: 8)
      story.task_points.build(project_task_id: project_task4.id, point_50: 1, point_90: 3)
      story.task_points.build(project_task_id: project_task5.id, point_50: 2, point_90: 5)
      story
    end
    let(:sub_category1) do
      sub_category = SubCategory.new(name: "SubCategory1")
      sub_category.stories << story1
      sub_category.stories << story2
      sub_category
    end
    let(:sub_category2) do
      sub_category = SubCategory.new(name: "SubCategory2")
      sub_category.stories << story3
      sub_category
    end
    before do
      @category = Category.new(project_id: 1, name: "Category")
      @category.sub_categories << sub_category1
      @category.sub_categories << sub_category2
      @category.save!
    end
    describe "sum_of_point_50 method" do
      subject{ @category.sum_of_point_50 }
      it{ is_expected.to eq 45 }
    end
    describe "sum_of_point_50_by_project_task_id method" do
      subject{ @category.sum_of_point_50_by_project_task_id(project_task3.id) }
      it{ is_expected.to eq 12 }
    end
    describe "sum_of_square_of_diff method" do
      subject{ @category.sum_of_square_of_diff }
      it{ is_expected.to eq 109 }
    end
    describe "total_price method" do
      subject{ @category.total_price(1.2, 0.5) }
      it{ is_expected.to eq 1179000 }
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
    let(:sub_category1) do
      sub_category = SubCategory.new(name: "SubCategory1")
      sub_category.stories << story1
      sub_category
    end
    let(:sub_category2) do
      sub_category = SubCategory.new(name: "SubCategory2")
      sub_category.stories << story2
      sub_category
    end
    let(:org_category) do
      category = Category.new(name: "Category1")
      category.sub_categories << sub_category1
      category.sub_categories << sub_category2
      category
    end
    before do
      @project_task_id_map = { 1 => 11, 2 => 12 }
      @new_category = org_category.dup_deep(@project_task_id_map)
    end
    context "check category value, " do
      subject{ @new_category }

      describe '#name' do
        subject { super().name }
        it { is_expected.to eq "Category1" }
      end
    end
    context "check sub_categories counts, " do
      subject { @new_category.sub_categories }
      it'has 2 items' do
        expect(subject.size).to eq(2)
      end
    end
    context "check sub_categories values, " do
      specify do
        @new_category.sub_categories.each_with_index do |sub_category, i|
          org_sub_category = org_category.sub_categories[i]
          expect(sub_category.name).to eq org_sub_category.name
          sub_category.stories.each_with_index do |story, j|
            org_story = org_sub_category.stories[j]
            expect(story.name).to eq org_story.name
            story.task_points.each_with_index do |tp, k|
              org_tp = org_story.task_points[k]
              expect(tp.project_task_id).to eq @project_task_id_map[org_tp.project_task_id]
              expect(tp.point_50).to eq org_tp.point_50
              expect(tp.point_90).to eq org_tp.point_90
            end
          end
        end
      end
    end
  end
end
