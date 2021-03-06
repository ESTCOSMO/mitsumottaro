require 'spec_helper'

describe ProjectTasksController, :type => :controller do
  before do
    @project = Project.new(name: 'Sample', days_per_point: 0.5)
    @project.save!
  end

  describe "GET 'index'" do
    before { get :index, { project_id: @project.id } }
    subject { response }
    it { is_expected.to be_success }
    it { is_expected.to render_template(:index) }
  end

  describe "POST 'create'" do
    context 'when input correct data, ' do
      before do
       xhr :post, :create, { project_id: @project.id,
                        project_task: { name: 'ProjectTaskName', price_per_day: 70000} }
      end
      describe 'check redirect path' do
        subject { response }
        it { is_expected.to redirect_to project_project_tasks_path(@project) }
      end
      describe 'check saved data' do
        subject { ProjectTask.where(project_id: @project.id).first}

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq 'ProjectTaskName' }
        end

        describe '#price_per_day' do
          subject { super().price_per_day }
          it { is_expected.to eq 70000 }
        end
      end
    end
    context 'when name is empty, ' do
      before do
        xhr :post, :create, { project_id: @project.id,
                        project_task: { name: '', price_per_day: 70000} }
      end
      describe 'check response status' do
        subject { response.status }
        it { is_expected.to eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
    context 'when price_per_day is empty, ' do
      before do
        xhr :post, :create, { project_id: @project.id,
                        project_task: { name: 'ProjectTaskName', price_per_day: ''} }
      end
      describe 'check response status' do
        subject { response.status }
        it { is_expected.to eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
  end

  describe "POST 'update'" do
    before do
      @project_task = @project.project_tasks.build(name: 'SampleTask', price_per_day: 40000)
      @project.save!
    end
    context 'when input correct data, ' do
      before do
        xhr :post, :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: 'UpdatedTask', price_per_day: 70000} }
      end
      describe 'check redirect path' do
        subject { response }
        it { is_expected.to redirect_to project_project_tasks_path(@project) }
      end
      describe 'check saved data' do
        subject { ProjectTask.where(project_id: @project.id).first}

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq 'UpdatedTask' }
        end

        describe '#price_per_day' do
          subject { super().price_per_day }
          it { is_expected.to eq 70000 }
        end
      end
    end
    context 'when name is empty, ' do
      before do
        xhr :post, :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: '', price_per_day: 70000} }
      end
      describe 'check response status' do
        subject { response.status }
        it { is_expected.to eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
    context 'when price_per_day is empty, ' do
      before do
        xhr :post, :update, { project_id: @project.id, id: @project_task.id,
                        project_task: { name: 'UpdatedTask', price_per_day: ''} }
      end
      describe 'check response status' do
        subject { response.status }
        it { is_expected.to eq Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @project_task = @project.project_tasks.build(name: 'SampleTask', price_per_day: 40000)
      @project.save!
      delete :destroy, { project_id: @project.id, id: @project_task.id }
    end
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_project_tasks_path(@project) }
    end
    describe 'check deleted data' do
      subject { ProjectTask.where(project_id: @project.id).size}
      it { is_expected.to eq 0 }
    end
  end

  describe "GET 'move_higher'" do
    before do
      @project_task1 = @project.project_tasks.build(name: 'SampleTask1', price_per_day: 40000, position: 1)
      @project_task2 = @project.project_tasks.build(name: 'SampleTask2', price_per_day: 50000, position: 2)
      @project_task3 = @project.project_tasks.build(name: 'SampleTask3', price_per_day: 60000, position: 3)
      @project.save!
      get :move_higher, { project_id: @project.id, id: @project_task2.id }
    end
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_dashboard_path(@project, anchor: "/projects/#{@project.id}/dashboard") }
    end
    describe 'check items order' do
      before { @project_tasks = ProjectTask.where(project_id: @project.id).order(:position) }
      specify do
        expect(@project_tasks[0]).to eq @project_task2
        expect(@project_tasks[1]).to eq @project_task1
        expect(@project_tasks[2]).to eq @project_task3
      end
    end
  end

  describe "GET 'move_lower'" do
    before do
      @project_task1 = @project.project_tasks.build(name: 'SampleTask1', price_per_day: 40000, position: 1)
      @project_task2 = @project.project_tasks.build(name: 'SampleTask2', price_per_day: 50000, position: 2)
      @project_task3 = @project.project_tasks.build(name: 'SampleTask3', price_per_day: 60000, position: 3)
      @project.save!
      get :move_lower, { project_id: @project.id, id: @project_task2.id }
    end
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_dashboard_path(@project, anchor: "/projects/#{@project.id}/dashboard") }
    end
    describe 'check items order' do
      before { @project_tasks = ProjectTask.where(project_id: @project.id).order(:position) }
      specify do
        expect(@project_tasks[0]).to eq @project_task1
        expect(@project_tasks[1]).to eq @project_task3
        expect(@project_tasks[2]).to eq @project_task2
      end
    end
  end
end
