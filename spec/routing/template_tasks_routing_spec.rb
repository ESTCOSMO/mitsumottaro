require "spec_helper"

describe TemplateTasksController do
  describe "routing" do
    describe "routes to #index" do
      context "when using url," do
        subject{ { get:"/template_tasks" } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "index") }
      end
      context "when using prefix_path," do
        subject{ { get: template_tasks_path } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "index") }
      end
    end

    describe "routes to #new" do
      context "when using url," do
        subject{ { get:"/template_tasks/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "new") }
      end
      context "when using prefix_path," do
        subject{ { get: new_template_task_path } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "new") }
      end
    end

    describe "routes to #show" do
      context "when using url," do
        subject{ { get:"/template_tasks/1" } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "show", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: template_task_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "show", id: "1") }
      end
    end

    describe "routes to #edit" do
      context "when using url," do
        subject{ { get:"/template_tasks/1/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "edit", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_template_task_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "template_tasks", action: "edit", id: "1") }
      end
    end

    describe "routes to #create" do
      subject{ { post: "/template_tasks" } }
      it{ should route_to(controller: "template_tasks", action: "create") }
    end

    describe "routes to #update" do
      subject{ { put: "/template_tasks/1" } }
      it{ should route_to(controller: "template_tasks", action: "update", id: "1") }
    end

    describe "routes to #destroy" do
      subject{ { delete: "/template_tasks/1" } }
      it{ should route_to(controller: "template_tasks", action: "destroy", id: "1") }
    end

    %w( move_higher move_lower ).each do |action|
      describe "routes to ##{action}" do
        context "when using url," do
          subject{ { patch:"/template_tasks/1/#{action}" } }
          it{ should be_routable }
          it{ should route_to(controller: "template_tasks", action: "#{action}", id: "1") }
        end
        context "when using prefix_path," do
          subject{ { patch: send("#{action}_template_task_path", {id: 1}) } }
          it{ should be_routable }
          it{ should route_to(controller: "template_tasks", action: "#{action}", id: "1") }
        end
      end
    end
  end
end
