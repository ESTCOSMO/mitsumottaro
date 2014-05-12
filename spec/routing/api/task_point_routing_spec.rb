# -*- coding: utf-8 -*-
require "spec_helper"

describe Api::TaskPointsController do
  describe "routing" do
    describe "routes to #create" do
      subject{ { post: "/api/projects/1/categories/2/sub_categories/3/stories/4/task_points" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/task_points", action: "create", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
    end
    describe "routes to #destroy" do
      subject{ { delete: "/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/5" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/task_points", action: "destroy", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
    end

    # 以下、Routing定義はされているがControllerでの定義がない
    describe "routes to #index" do
      context "when using url," do
        subject{ { get:"/api/projects/1/categories/2/sub_categories/3/stories/4/task_points" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "index", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: api_project_category_sub_category_story_task_points_path(project_id: 1, category_id: 2, sub_category_id: 3, story_id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "index", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
      end
    end
    describe "routes to #new" do
      context "when using url," do
        subject{ { get:"/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "new", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: new_api_project_category_sub_category_story_task_point_path(project_id: 1, category_id: 2, sub_category_id: 3, story_id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "new", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
      end
    end
    describe "routes to #show" do
      context "when using url," do
        subject{ { get:"/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/5" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "show", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
      end
      context "when using prefix_path," do
        subject{ { get: api_project_category_sub_category_story_task_point_path(project_id: 1, category_id: 2, sub_category_id: 3, story_id: 4, id: 5) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "show", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
      end
    end
    describe "routes to #edit" do
      context "when using url," do
        subject{ { get:"/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/5/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "edit", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_api_project_category_sub_category_story_task_point_path(project_id: 1, category_id: 2, sub_category_id: 3, story_id: 4, id: 5) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/task_points", action: "edit", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
      end
    end
    describe "routes to #update" do
      subject{ { put: "/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/5" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/task_points", action: "update", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
    end
  end
end
