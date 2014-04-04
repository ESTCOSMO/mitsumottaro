# -*- coding: utf-8 -*-
require 'spec_helper'

describe TemplateTasksController do

  # This should return the minimal set of attributes required to create a valid
  # TemplateTask. As you add validations to TemplateTask, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { name: "要件定義", price_per_day: 50000 }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TemplateTasksController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all template_tasks as @template_tasks" do
      template_task = TemplateTask.create! valid_attributes
      get :index, {}, valid_session
      assigns(:template_tasks).should eq([template_task])
    end
  end

  describe "GET new" do
    it "assigns a new template_task as @template_task" do
      get :new, {}, valid_session
      assigns(:template_task).should be_a_new(TemplateTask)
    end
  end

  describe "GET edit" do
    it "assigns the requested template_task as @template_task" do
      template_task = TemplateTask.create! valid_attributes
      get :edit, {:id => template_task.to_param}, valid_session
      assigns(:template_task).should eq(template_task)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TemplateTask" do
        expect {
          post :create, {:template_task => valid_attributes}, valid_session
        }.to change(TemplateTask, :count).by(1)
      end

      it "assigns a newly created template_task as @template_task" do
        post :create, {:template_task => valid_attributes}, valid_session
        assigns(:template_task).should be_a(TemplateTask)
        assigns(:template_task).should be_persisted
      end

      it "redirects to index" do
        post :create, {:template_task => valid_attributes}, valid_session
        response.should redirect_to(template_tasks_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved template_task as @template_task" do
        # Trigger the behavior that occurs when invalid params are submitted
        TemplateTask.any_instance.stub(:save).and_return(false)
        post :create, {:template_task => { "name" => "invalid value" }}, valid_session
        assigns(:template_task).should be_a_new(TemplateTask)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TemplateTask.any_instance.stub(:save).and_return(false)
        post :create, {:template_task => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested template_task" do
        template_task = TemplateTask.create! valid_attributes
        # Assuming there are no other template_tasks in the database, this
        # specifies that the TemplateTask created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TemplateTask.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => template_task.to_param, :template_task => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested template_task as @template_task" do
        template_task = TemplateTask.create! valid_attributes
        put :update, {:id => template_task.to_param, :template_task => valid_attributes}, valid_session
        assigns(:template_task).should eq(template_task)
      end

      it "redirects to index" do
        template_task = TemplateTask.create! valid_attributes
        put :update, {:id => template_task.to_param, :template_task => valid_attributes}, valid_session
        response.should redirect_to(template_tasks_url)
      end
    end

    describe "with invalid params" do
      it "assigns the template_task as @template_task" do
        template_task = TemplateTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TemplateTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => template_task.to_param, :template_task => { "name" => "invalid value" }}, valid_session
        assigns(:template_task).should eq(template_task)
      end

      it "re-renders the 'edit' template" do
        template_task = TemplateTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TemplateTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => template_task.to_param, :template_task => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested template_task" do
      template_task = TemplateTask.create! valid_attributes
      expect {
        delete :destroy, {:id => template_task.to_param}, valid_session
      }.to change(TemplateTask, :count).by(-1)
    end

    it "redirects to the template_tasks list" do
      template_task = TemplateTask.create! valid_attributes
      delete :destroy, {:id => template_task.to_param}, valid_session
      response.should redirect_to(template_tasks_url)
    end
  end

end
