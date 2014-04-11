# -*- coding: utf-8 -*-
require 'spec_helper'

describe Project do
  describe "field definitions" do
    subject { Project.new }
    it { should respond_to(:name) }
    it { should respond_to(:days_per_point) }
    it { should respond_to(:categories) }
    it { should respond_to(:project_tasks) }
    it { should respond_to(:additional_costs) }
    it { should respond_to(:template_tasks) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { Project.new(name: "Project", days_per_point: 0.5) }
      it { should be_valid }
    end
    context "when name is not present," do
      subject { Project.new(name: " ") }
      it{ should have(1).error_on(:name) }
    end
    context "when days_per_point is not present," do
      subject { Project.new(days_per_point: " ") }
      it{ should_not have(1).error_on(:days_per_point) }
    end
  end

  context "when category destroy" do
    let(:project){Project.new(name: "Project")}
    context "case categories," do
      before do
        project.categories.build(name: "Category")
        project.save!
      end
      it "projectを削除したらcategoryも削除されること" do
        Category.where(project_id: project.id).size.should eq 1
        project.destroy!
        Category.where(project_id: project.id).size.should eq 0
      end
    end
    context "case project_tasks," do
      let(:template_task1){ TemplateTask.create(name:"TemplateTask", price_per_day: 50000) }
      before do
        project.project_tasks.build(name: "ProjectTask", price_per_day: 20000)
        project.save!
      end
      it "projectを削除したらproject_taskも削除されること" do
        ProjectTask.where(project_id: project.id).size.should eq 1
        project.destroy!
        ProjectTask.where(project_id: project.id).size.should eq 0
      end
    end
    context "case additional_costs," do
      before do
        project.additional_costs.build(name: "Additional", price: 120000)
        project.save!
      end
      it "projectを削除したらadditional_costsも削除されること" do
        AdditionalCost.where(project_id: project.id).size.should eq 1
        project.destroy!
        AdditionalCost.where(project_id: project.id).size.should eq 0
      end
    end
    context "case template_tasks," do
      let(:template_task1){ TemplateTask.create(name:"TemplateTask", price_per_day: 50000) }
      before do
        project.project_tasks.build(template_task_id: template_task1.id, name: "ProjectTask", price_per_day: 20000)
        project.save!
      end
      it "projectを削除したときtemplate_taskは削除されないこと" do
        TemplateTask.where(id: template_task1.id).size.should eq 1
        project.destroy!
        TemplateTask.where(id: template_task1.id).size.should_not eq 0
      end
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
    let(:story4) do
      story = Story.new(name: "Story4")
      story.task_points.build(project_task_id: project_task3.id, point_50: 8, point_90: 13)
      story.task_points.build(project_task_id: project_task5.id, point_50: 3, point_90: 8)
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
    let(:sub_category3) do
      sub_category = SubCategory.new(name: "SubCategory3")
      sub_category.stories << story4
      sub_category
    end
    let(:category1) do
      category = Category.new(name: "Category1")
      category.sub_categories << sub_category1
      category.sub_categories << sub_category2
      category
    end
    let(:category2) do
      category = Category.new(name: "Category2")
      category.sub_categories << sub_category3
      category
    end

    before do
      @project = Project.new(name: "Test Project", days_per_point: 0.5)
      @project.categories << category1
      @project.categories << category2
      @project.save!
    end
    describe "sum_of_point_50 method" do
      subject{ @project.sum_of_point_50 }
      it{ should eq 56 }
    end
    describe "sum_of_point_50_by_project_task_id method" do
      subject{ @project.sum_of_point_50_by_project_task_id(3) }
      it{ should eq 20 }
    end
    describe "sum_of_square_of_diff method" do
      subject{ @project.sum_of_square_of_diff }
      it{ should eq 159 }
    end
    describe "buffer method" do
      subject{ @project.buffer }
      it{ should eq 12.609520212918492 }
    end
    describe "total_price_with_buffer method" do
      subject{ @project.total_price_with_buffer }
      it{ should eq 1525336.654733634 }
      # it{ should eq 1525336.6547336343 }
    end
    describe "total_price_50 method" do
      subject{ @project.total_price_50 }
      it{ should eq 1245000 }
    end
  end

  describe "dup_deep" do
    pending "項目複製のテストを実装すること"
  end
end
