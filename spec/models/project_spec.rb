# -*- coding: utf-8 -*-
require 'spec_helper'

describe Project, :type => :model do
  describe "field definitions" do
    subject { Project.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:days_per_point) }
    it { is_expected.to respond_to(:categories) }
    it { is_expected.to respond_to(:project_tasks) }
    it { is_expected.to respond_to(:additional_costs) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { Project.new(name: "Project", days_per_point: 0.5) }
      it { is_expected.to be_valid }
    end
    context "when name is not present," do
      subject { Project.new(name: " ").tap(&:valid?).errors[:name].size }
      it { is_expected.to eq 1 }
    end
    context "when days_per_point is not present," do
      subject { Project.new(days_per_point: " ").tap(&:valid?).errors[:days_per_point].size }
      it { is_expected.to eq 0 }
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
        expect(Category.where(project_id: project.id).size).to eq 1
        project.destroy!
        expect(Category.where(project_id: project.id).size).to eq 0
      end
    end
    context "case project_tasks," do
      let(:template_task1){ TemplateTask.create(name:"TemplateTask", price_per_day: 50000) }
      before do
        project.project_tasks.build(name: "ProjectTask", price_per_day: 20000)
        project.save!
      end
      it "projectを削除したらproject_taskも削除されること" do
        expect(ProjectTask.where(project_id: project.id).size).to eq 1
        project.destroy!
        expect(ProjectTask.where(project_id: project.id).size).to eq 0
      end
    end
    context "case additional_costs," do
      before do
        project.additional_costs.build(name: "Additional", price: 120000)
        project.save!
      end
      it "projectを削除したらadditional_costsも削除されること" do
        expect(AdditionalCost.where(project_id: project.id).size).to eq 1
        project.destroy!
        expect(AdditionalCost.where(project_id: project.id).size).to eq 0
      end
    end
    context "case template_tasks," do
      let(:template_task1){ TemplateTask.create(name:"TemplateTask", price_per_day: 50000) }
      before do
        project.project_tasks.build(template_task_id: template_task1.id, name: "ProjectTask", price_per_day: 20000)
        project.save!
      end
      it "projectを削除したときtemplate_taskは削除されないこと" do
        expect(TemplateTask.where(id: template_task1.id).size).to eq 1
        project.destroy!
        expect(TemplateTask.where(id: template_task1.id).size).not_to eq 0
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
      it{ is_expected.to eq 56 }
    end
    describe "sum_of_point_50_by_project_task_id method" do
      subject{ @project.sum_of_point_50_by_project_task_id(project_task3.id) }
      it{ is_expected.to eq 20 }
    end
    describe "sum_of_square_of_diff method" do
      subject{ @project.sum_of_square_of_diff }
      it{ is_expected.to eq 159 }
    end
    describe "buffer method" do
      subject{ @project.buffer }
      it{ is_expected.to eq 12.609520212918492 }
    end
    describe "total_price_with_buffer method" do
      subject{ @project.total_price_with_buffer.to_f }
      it{ is_expected.to be_within(1.0e-05).of(1525336.65473) }
    end
    describe "total_price_50 method" do
      subject{ @project.total_price_50 }
      it{ is_expected.to eq 1245000 }
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

      describe '#name' do
        subject { super().name }
        it { is_expected.to eq "Test Project (コピー)" }
      end

      describe '#days_per_point' do
        subject { super().days_per_point }
        it { is_expected.to eq 0.5 }
      end

      describe '#categories' do
        subject { super().categories }
        it { is_expected.to be_empty }
      end

      describe '#project_tasks' do
        subject { super().project_tasks }
        it { is_expected.to be_empty }
      end

      describe '#additional_costs' do
        subject { super().additional_costs }
        it { is_expected.to be_empty }
      end
      context "when project archived is true, " do
        before{ org_project.archive! }
        subject{ org_project.dup_project! }

        describe '#archived' do
          subject { super().archived }
          it { is_expected.to be_falsey }
        end
      end
    end
    describe "dup_additional_costs! method: " do
      before do
        @new_project = Project.new(name: 'DupProject')
        org_project.dup_additional_costs!(@new_project)
      end
      context "check additional_costs counts" do
        subject{ @new_project.additional_costs }
        it'has 1 item' do
          expect(subject.size).to eq(1)
        end
      end
      context "check additional_costs values" do
        specify do
          @new_project.additional_costs.each_with_index do |ac, idx|
            expect(ac.name).to eq org_project.additional_costs[idx].name
            expect(ac.price).to eq org_project.additional_costs[idx].price
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
        it 'has 2 items' do
          expect(subject.size).to eq(2)
        end
        it "値がコピーされていること" do
          @new_project.project_tasks.each_with_index do |pt, idx|
            expect(pt.name).to eq org_project.project_tasks[idx].name
            expect(pt.price_per_day).to eq org_project.project_tasks[idx].price_per_day
          end
        end
      end
      context "check project_task_id_map counts, " do
        subject{ @project_task_id_map }
        it 'has 2 items' do
          expect(subject.size).to eq(2)
        end
      end
      context "check project_task_id_map values, " do
        specify do
          expect(@project_task_id_map[org_project.project_tasks[0].id]).to eq @new_project.project_tasks[0].id
          expect(@project_task_id_map[org_project.project_tasks[1].id]).to eq @new_project.project_tasks[1].id
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
        it'has 1 item' do
          expect(subject.size).to eq(1)
        end
      end
      context "check categories and children's item values, " do
        specify do
          @new_project.categories.each_with_index do |category, i|
            org_category = org_project.categories[i]
            expect(category.name).to eq org_category.name
            category.sub_categories.each_with_index do |sub_category, j|
              org_sub_category = org_category.sub_categories[j]
              expect(sub_category.name).to eq org_sub_category.name
              sub_category.stories.each_with_index do |story, k|
                org_story = org_sub_category.stories[k]
                expect(story.name).to eq org_story.name
                story.task_points.each_with_index do |tp, l|
                  org_tp = org_story.task_points[l]
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
    describe "dup_deep! method: " do
      before do
        @new_project = org_project.dup_deep!
      end
      context "check project values, " do
        subject{ @new_project }

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq "Test Project (コピー)" }
        end

        describe '#days_per_point' do
          subject { super().days_per_point }
          it { is_expected.to eq 0.5 }
        end
      end
      context "check additional_costs counts" do
        subject{ @new_project.additional_costs }
        it'has 1 item' do
          expect(subject.size).to eq(1)
        end
      end
      context "check additional_cost values, " do
        specify do
          @new_project.additional_costs.each_with_index do |ac, idx|
            expect(ac.name).to eq org_project.additional_costs[idx].name
            expect(ac.price).to eq org_project.additional_costs[idx].price
          end
        end
      end
      context "check project_tasks counts, " do
        subject{ @new_project.project_tasks }
        it 'has 2 items' do
          expect(subject.size).to eq(2)
        end
      end
      context "check project_tasks values, " do
        specify do
          @new_project.project_tasks.each_with_index do |pt, idx|
            expect(pt.name).to eq org_project.project_tasks[idx].name
            expect(pt.price_per_day).to eq org_project.project_tasks[idx].price_per_day
          end
        end
      end
      context "check categories value, " do
        subject{ @new_project.categories }
        it'has 1 item' do
          expect(subject.size).to eq(1)
        end
      end
      context "check categories and children's item values, " do
        specify do
          @new_project.categories.each_with_index do |category, i|
            org_category = org_project.categories[i]
            expect(category.name).to eq org_category.name
            category.sub_categories.each_with_index do |sub_category, j|
              org_sub_category = org_category.sub_categories[j]
              expect(sub_category.name).to eq org_sub_category.name
              sub_category.stories.each_with_index do |story, k|
                org_story = org_sub_category.stories[k]
                expect(story.name).to eq org_story.name
                story.task_points.each_with_index do |tp, l|
                  org_tp = org_story.task_points[l]
                  expect(tp.point_50).to eq org_tp.point_50
                  expect(tp.point_90).to eq org_tp.point_90
                end
              end
            end
          end
        end
      end
    end
  end
  describe "add_default_project_tasks" do
    let(:template_task){TemplateTask.new(name: "Task", price_per_day: 40000, default_task: false)}
    let(:default_template_task){TemplateTask.new(name: "Default Task", price_per_day: 50000, default_task: true)}
    before do
      template_task.save!
      default_template_task.save!
      @project = Project.new(name: "New Project")
      @project.add_default_project_tasks
      @project.save!
    end
    it "default設定のTemplateTaskがProjectTaskとして登録されること" do
      project_tasks = ProjectTask.where(project_id: @project.id)
      expect(project_tasks.count).to eq 1
      expect(project_tasks[0].name).to eq "Default Task"
      expect(project_tasks[0].price_per_day).to eq 50000
    end
  end
  describe "archive!" do
    before do
      @project = Project.create(name: "Project", archived: false)
      @project.archive!
    end
    subject{ Project.find(@project.id) }

    describe '#archived' do
      subject { super().archived }
      it { is_expected.to be_truthy }
    end
  end
  describe "active!" do
    before do
      @project = Project.create(name: "Project", archived: true)
      @project.active!
    end
    subject{ Project.find(@project.id) }

    describe '#archived' do
      subject { super().archived }
      it { is_expected.to be_falsey }
    end
  end
end
