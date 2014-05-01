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
      subject{ @project.sum_of_point_50_by_project_task_id(project_task3.id) }
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
      subject{ @project.total_price_with_buffer.to_f }
      it{ should be_within(1.0e-05).of(1525336.65473) }
    end
    describe "total_price_50 method" do
      subject{ @project.total_price_50 }
      it{ should eq 1245000 }
    end
  end

  describe "項目のコピーを確認する, " do
    let(:template_task1){ FactoryGirl.create(:template_task1) }
    let(:template_task2){ FactoryGirl.create(:template_task2) }
    let(:project_task1){ FactoryGirl.create(:project_task1, template_task_id: template_task1.id, price_per_day: 50000) }
    let(:project_task2){ FactoryGirl.create(:project_task2, template_task_id: template_task2.id, price_per_day: 40000) }
    let(:story1) do
      story = Story.new(name: "Story1")
      story.task_points.build(project_task_id: project_task1.id, point_50: 3, point_90: 5)
      story.task_points.build(project_task_id: project_task2.id, point_50: 5, point_90: 8)
      story
    end
    let(:story2) do
      story = Story.new(name: "Story2")
      story.task_points.build(project_task_id: project_task1.id, point_50: 1, point_90: 2)
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
    let(:category1) do
      category = Category.new(name: "Category1")
      category.sub_categories << sub_category1
      category.sub_categories << sub_category2
      category
    end
    let(:additional_cost1){ AdditionalCost.create(name: "Additional", price: 40000)}
    let(:org_project) do
      project = Project.new(name: "Test Project", days_per_point: 0.5)
      project.categories << category1
      project.project_tasks << project_task1
      project.project_tasks << project_task2
      project.additional_costs << additional_cost1
      project.save!
      project
    end
    describe "dup_project! method: " do
      subject{ org_project.dup_project! }
      its(:name) { should eq "Test Project (コピー)" }
      its(:days_per_point) { should eq 0.5 }
      its(:categories) { should be_empty }
      its(:project_tasks) { should be_empty }
      its(:additional_costs) { should be_empty }
      its(:template_tasks) { should be_empty }
    end
    describe "dup_additional_costs! method: " do
      before do
        @new_project = Project.new(name: 'DupProject')
        org_project.dup_additional_costs!(@new_project)
      end
      context "check additional_costs counts" do
        subject{ @new_project.additional_costs }
        it{ should have(1).items }
      end
      context "check additional_costs values" do
        specify do
          @new_project.additional_costs.each_with_index do |ac, idx|
            ac.name.should eq org_project.additional_costs[idx].name
            ac.price.should eq org_project.additional_costs[idx].price
          end
        end
      end
    end
    describe "dup_project_tasks! method: " do
      before do
        @new_project = Project.new(name: 'DupProject')
        @project_task_id_map = org_project.dup_project_tasks!(@new_project)
      end
      context "check project_tasks value, " do
        subject{ @new_project.project_tasks }
        it { should have(2).items }
        it "値がコピーされていること" do
          @new_project.project_tasks.each_with_index do |pt, idx|
            pt.name.should eq org_project.project_tasks[idx].name
            pt.price_per_day.should eq org_project.project_tasks[idx].price_per_day
          end
        end
      end
      context "check template_tasks counts, " do
        subject{ @new_project.template_tasks }
        it { should have(2).items }
      end
      context "check template_tasks value, " do
        specify do
          @new_project.template_tasks.each_with_index do |tt, idx|
            tt.name.should eq org_project.template_tasks[idx].name
            tt.price_per_day.should eq org_project.template_tasks[idx].price_per_day
          end
        end
      end
      context "check project_task_id_map counts, " do
        subject{ @project_task_id_map }
        it { should have(2).items }
      end
      context "check project_task_id_map values, " do
        specify do
          @project_task_id_map[org_project.project_tasks[0].id].should eq @new_project.project_tasks[0].id
          @project_task_id_map[org_project.project_tasks[1].id].should eq @new_project.project_tasks[1].id
        end
      end
    end
    describe "dup_categories_deep! method: " do
      before do
        @new_project = Project.new(name: 'DupProject')
        @project_task_id_map = org_project.dup_project_tasks!(@new_project)
        org_project.dup_categories_deep!(@new_project, @project_task_id_map)
      end
      context "check categories counts, " do
        subject{ @new_project.categories }
        it{ should have(1).items }
      end
      context "check categories and children's item values, " do
        specify do
          @new_project.categories.each_with_index do |category, i|
            org_category = org_project.categories[i]
            category.name.should eq org_category.name
            category.sub_categories.each_with_index do |sub_category, j|
              org_sub_category = org_category.sub_categories[j]
              sub_category.name.should eq org_sub_category.name
              sub_category.stories.each_with_index do |story, k|
                org_story = org_sub_category.stories[k]
                story.name.should eq org_story.name
                story.task_points.each_with_index do |tp, l|
                  org_tp = org_story.task_points[l]
                  tp.project_task_id.should eq @project_task_id_map[org_tp.project_task_id]
                  tp.point_50.should eq org_tp.point_50
                  tp.point_90.should eq org_tp.point_90
                end
              end
            end
          end
        end
      end
    end
    describe "dup_deep! method: " do
      before do
        @new_project = org_project.dup_deep!
      end
      context "check project values, " do
        subject{ @new_project }
        its(:name) { should eq "Test Project (コピー)" }
        its(:days_per_point) { should eq 0.5 }
      end
      context "check additional_costs counts" do
        subject{ @new_project.additional_costs }
        it{ should have(1).items }
      end
      context "check additional_cost values, " do
        specify do
          @new_project.additional_costs.each_with_index do |ac, idx|
            ac.name.should eq org_project.additional_costs[idx].name
            ac.price.should eq org_project.additional_costs[idx].price
          end
        end
      end
      context "check project_tasks counts, " do
        subject{ @new_project.project_tasks }
        it { should have(2).items }
      end
      context "check project_tasks values, " do
        specify do
          @new_project.project_tasks.each_with_index do |pt, idx|
            pt.name.should eq org_project.project_tasks[idx].name
            pt.price_per_day.should eq org_project.project_tasks[idx].price_per_day
          end
        end
      end
      context "check template_tasks counts, " do
        subject{ @new_project.template_tasks }
        it { should have(2).items }
      end
      context "check template_tasks values, " do
        specify do
          @new_project.template_tasks.each_with_index do |tt, idx|
            tt.name.should eq org_project.template_tasks[idx].name
            tt.price_per_day.should eq org_project.template_tasks[idx].price_per_day
          end
        end
      end
      context "check categories value, " do
        subject{ @new_project.categories }
        it{ should have(1).items }
      end
      context "check categories and children's item values, " do
        specify do
          @new_project.categories.each_with_index do |category, i|
            org_category = org_project.categories[i]
            category.name.should eq org_category.name
            category.sub_categories.each_with_index do |sub_category, j|
              org_sub_category = org_category.sub_categories[j]
              sub_category.name.should eq org_sub_category.name
              sub_category.stories.each_with_index do |story, k|
                org_story = org_sub_category.stories[k]
                story.name.should eq org_story.name
                story.task_points.each_with_index do |tp, l|
                  org_tp = org_story.task_points[l]
                  tp.point_50.should eq org_tp.point_50
                  tp.point_90.should eq org_tp.point_90
                end
              end
            end
          end
        end
      end
    end
  end
end
