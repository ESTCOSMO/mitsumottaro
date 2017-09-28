require 'spec_helper'

describe Api::ProjectsController, :type => :routing do
  describe 'routing' do
    describe 'routes to #show' do
      context 'when using url,' do
        subject{ { get: '/api/projects/1' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/projects', action: 'show', id: '1') }
      end
      context 'when using prefix_path,' do
        subject{ { get: api_project_path(id: 1) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/projects', action: 'show', id: '1') }
      end
    end
    describe 'routes to #create' do
      subject{ { post: '/api/projects' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'api/projects', action: 'create') }
    end
    describe 'routes to #update' do
      subject{ { put: '/api/projects/1' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'api/projects', action: 'update', id: '1') }
    end
  end
end
