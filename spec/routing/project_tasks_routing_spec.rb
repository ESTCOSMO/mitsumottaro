require 'spec_helper'

describe ProjectTasksController, :type => :routing do
  describe 'routing' do
    describe 'routes to #index,' do
      context 'when using url,' do
        subject{ { get:'/projects/1/project_tasks' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'index', project_id: '1') }
      end
      context 'when using prefix_path,' do
        subject{ { get: project_project_tasks_path(project_id: 1) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'index', project_id: '1') }
      end
    end

    describe 'routes to #move_higher,' do
      context 'when using url,' do
        subject{ { get:'/projects/1/project_tasks/2/move_higher' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'move_higher', project_id: '1', id: '2') }
      end
      context 'when using prefix_path,' do
        subject{ { get: move_higher_project_project_task_path(project_id: 1, id: 2) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'move_higher', project_id: '1', id: '2') }
      end
    end

    describe 'routes to #move_lower,' do
      context 'when using url,' do
        subject{ { get:'/projects/1/project_tasks/2/move_lower' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'move_lower', project_id: '1', id: '2') }
      end
      context 'when using prefix_path,' do
        subject{ { get: move_lower_project_project_task_path(project_id: 1, id: 2) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'project_tasks', action: 'move_lower', project_id: '1', id: '2') }
      end
    end

    describe 'routes to #create' do
      subject{ { post: '/projects/1/project_tasks' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'project_tasks', action: 'create', project_id: '1') }
    end

    describe 'routes to #update' do
      subject{ { put: '/projects/1/project_tasks/2' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'project_tasks', action: 'update', project_id: '1', id: '2') }
    end

    describe 'routes to #destroy' do
      subject{ { delete: '/projects/1/project_tasks/2' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'project_tasks', action: 'destroy', project_id: '1', id: '2') }
    end
  end
end
