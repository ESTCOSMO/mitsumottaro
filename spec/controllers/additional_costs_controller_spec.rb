require 'spec_helper'

describe AdditionalCostsController do

  before do
    @project = Project.new(name: "Sample", days_per_point: 0.5)
    @project.save!
  end

  describe "GET 'index'" do
    before{ get :index, { project_id: @project.id } }
    subject{ response }
    it{ should be_success }
  end

  describe "GET 'new'" do
    before{ get :new, { project_id: @project.id } }
    subject{ response }
    it{ should be_success }
  end

  describe "GET 'edit'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000)
      @additional_cost.save!
      get :edit, { project_id: @project.id , id: @additional_cost.id }
    end
    subject{ response }
    it{ should be_success }
  end

  describe "POST 'create'" do
    context "when input correct data, " do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: 'Additional', price: 10000 }}
      end
      describe "check redirect path" do
        subject{ response }
        it{ should redirect_to project_additional_costs_url(@project) }
      end
      describe "check saved data" do
        subject{ AdditionalCost.where(project_id: @project.id).first }
        its(:name){ should eq "Additional" }
        its(:price){ should eq 10000 }
      end
    end
    context "when name is empty, " do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: '', price: 10000 }}
      end
      describe "check response template" do
        subject{ response }
        it{ should render_template "new" }
      end
    end
    context "when price is empty, " do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: 'Additional', price: '' }}
      end
      describe "check response template" do
        subject{ response }
        it{ should render_template "new" }
      end
    end
  end

  describe "POST 'upadte'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000)
      @additional_cost.save!
    end
    context "when input correct data, " do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: 'EditedAdditional', price: 20000 }}
      end
      describe "check redirect path" do
        subject{ response }
        it{ should redirect_to project_additional_costs_url(@project) }
      end
      describe "check saved data" do
        subject{ AdditionalCost.where(project_id: @project.id).first }
        its(:name){ should eq "EditedAdditional" }
        its(:price){ should eq 20000 }
      end
    end
    context "when name is empty, " do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: '', price: 20000 }}
      end
      describe "check response template" do
        subject{ response }
        it{ should render_template "edit" }
      end
    end
    context "when price is empty, " do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: 'EditedAdditional', price: '' }}
      end
      describe "check response template" do
        subject{ response }
        it{ should render_template "edit" }
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000)
      @additional_cost.save!
    end
    before do
      delete :destroy, {  project_id: @project.id, id: @additional_cost.id }
    end
    describe "check redirect path" do
      subject{ response }
      it{ should redirect_to project_additional_costs_url(@project) }
    end
    describe "check deleted data" do
      subject{ AdditionalCost.where(project_id: @project.id) }
      its(:size){ should eq 0 }
    end
  end
end
