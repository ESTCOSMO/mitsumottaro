require 'spec_helper'

describe Api::StoriesController, :type => :routing do
  describe 'routing' do
    describe 'routes to #show' do
      context 'when using url,' do
        subject{ { get:'/api/projects/1/categories/2/sub_categories/3/stories/4' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'show', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
      end
      context 'when using prefix_path,' do
        subject{ { get: api_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'show', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
      end
    end
    describe 'routes to #move_higher' do
      context 'when using url,' do
        subject{ { patch: '/api/projects/1/categories/2/sub_categories/3/stories/4/move_higher' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'move_higher', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
      end
      context 'when using prefix_path,' do
        subject{ { patch: move_higher_api_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: '4') } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'move_higher', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
      end
    end
    describe 'routes to #move_lower' do
      context 'when using url,' do
        subject{ { patch: '/api/projects/1/categories/2/sub_categories/3/stories/4/move_lower' } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'move_lower', project_id: '1', category_id: '2', sub_category_id: '3' ,id: '4') }
     end
      context 'when using prefix_path,' do
        subject{ { patch: move_lower_api_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: 'api/stories', action: 'move_lower', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
      end
    end
    describe 'routes to #create' do
      subject{ { post:'/api/projects/1/categories/2/sub_categories/3/stories' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'api/stories', action: 'create', project_id: '1', category_id: '2', sub_category_id: '3') }
    end
    describe 'routes to #update' do
      subject{ { put:'/api/projects/1/categories/2/sub_categories/3/stories/4' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'api/stories', action: 'update', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
    end
    describe 'routes to #destroy' do
      subject{ { delete: '/api/projects/1/categories/2/sub_categories/3/stories/4' } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: 'api/stories', action: 'destroy', project_id: '1', category_id: '2', sub_category_id: '3', id: '4') }
    end
  end
end
