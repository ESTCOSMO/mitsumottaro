require "spec_helper"

describe TemplateTasksController do
  describe "routing" do

    it "routes to #index" do
      get("/template_tasks").should route_to("template_tasks#index")
    end

    it "routes to #new" do
      get("/template_tasks/new").should route_to("template_tasks#new")
    end

    it "routes to #show" do
      get("/template_tasks/1").should route_to("template_tasks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/template_tasks/1/edit").should route_to("template_tasks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/template_tasks").should route_to("template_tasks#create")
    end

    it "routes to #update" do
      put("/template_tasks/1").should route_to("template_tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/template_tasks/1").should route_to("template_tasks#destroy", :id => "1")
    end

  end
end
