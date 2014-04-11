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

end
