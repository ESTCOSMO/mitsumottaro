require 'spec_helper'

describe ProjectTasksController do
  before do
    @project = Project.new(name: "Sample", days_per_point: 0.5)
    @project.save!
  end

  describe "GET 'index'" do
    before{ get :index, { project_id: @project.id } }
    subject{ response }
    it { should be_success }
  end

  describe "POST 'create'" do
    context "when input correct data, " do
      before do
        post :create, { project_id: @project.id,
                        project_task: { name: "ProjectTaskName", price_per_day: 70000} }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_project_tasks_path(@project) }
      end
      describe "check saved data" do
        subject{ ProjectTask.where(project_id: @project.id).first}
        its(:name){ should eq "ProjectTaskName" }
        its(:price_per_day){ should eq 70000 }
      end
    end
    context "when name is empty, " do
      before do
        post :create, { project_id: @project.id,
                        project_task: { name: "", price_per_day: 70000} }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
    context "when price_per_day is empty, " do
      before do
        post :create, { project_id: @project.id,
                        project_task: { name: "ProjectTaskName", price_per_day: ''} }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
  end

  describe "POST 'update'" do
    before do
      @project_task = ProjectTask.new(project_id: @project.id, name: "SampleTask", price_per_day: 40000 )
      @project_task.save!
    end
    context "when input correct data, " do
      before do
        post :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: "UpdatedTask", price_per_day: 70000} }
      end
      describe "check redirect path" do
        subject{ response }
        it{  should redirect_to project_project_tasks_path(@project) }
      end
      describe "check saved data" do
        subject{ ProjectTask.where(project_id: @project.id).first}
        its(:name){ should eq "UpdatedTask" }
        its(:price_per_day){ should eq 70000 }
      end
    end
    context "when name is empty, " do
      before do
        post :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: "", price_per_day: 70000} }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
    context "when price_per_day is empty, " do
      before do
        post :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: "UpdatedTask", price_per_day: ""} }
      end
      describe "check response status" do
        subject{ response.status }
        it{  should eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @project_task = ProjectTask.new(project_id: @project.id, name: "SampleTask", price_per_day: 40000 )
      @project_task.save!
    end
    before do
      delete :destroy, { project_id: @project.id, id: @project_task.id }
    end
    describe "check redirect path" do
      subject{ response }
      it{  should redirect_to project_project_tasks_path(@project) }
    end
    describe "check deleted data" do
      subject{ ProjectTask.where(project_id: @project.id)}
      its(:size){ should eq 0 }
    end
  end
end
