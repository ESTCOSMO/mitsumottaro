# -*- coding: utf-8 -*-
require "spec_helper"

describe ProjectTasksController do
  describe "routing" do
    describe "routes to #index," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "index", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: project_project_tasks_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "index", project_id: "1") }
      end
    end

    describe "routes to #move_higher," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks/2/move_higher" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "move_higher", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: move_higher_project_project_task_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "move_higher", project_id: "1", id: "2") }
      end
    end

    describe "routes to #move_lower," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks/2/move_lower" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "move_lower", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: move_lower_project_project_task_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "move_lower", project_id: "1", id: "2") }
      end
    end

    describe "routes to #create" do
      subject{ { post: "/projects/1/project_tasks" } }
      it{ should be_routable }
      it{ should route_to(controller: "project_tasks", action: "create", project_id: "1") }
    end

    describe "routes to #update" do
      subject{ { put: "/projects/1/project_tasks/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "project_tasks", action: "update", project_id: "1", id: "2") }
    end

    describe "routes to #destroy" do
      subject{ { delete: "/projects/1/project_tasks/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "project_tasks", action: "destroy", project_id: "1", id: "2") }
    end

    # 以下、Routing定義はされているがControllerでの定義がない
    describe "routes to #new," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "new", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: new_project_project_task_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "new", project_id: "1") }
      end
    end

    describe "routes to #show," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks/2" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "show", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: project_project_task_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "show", project_id: "1", id: "2") }
      end
    end

    describe "routes to #edit," do
      context "when using url," do
        subject{ { get:"/projects/1/project_tasks/2/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "edit", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_project_project_task_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "project_tasks", action: "edit", project_id: "1", id: "2") }
      end
    end
  end
end
