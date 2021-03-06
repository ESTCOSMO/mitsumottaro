require 'spec_helper'

describe AdditionalCostsController, :type => :controller do

  before do
    @project = Project.new(name: 'Sample', days_per_point: 0.5)
    @project.save!
  end

  describe "GET 'index'" do
    before { get :index, { project_id: @project.id } }
    subject { response }
    it { is_expected.to be_success }
  end

  describe "GET 'new'" do
    before { get :new, { project_id: @project.id } }
    subject { response }
    it { is_expected.to be_success }
  end

  describe "GET 'edit'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000)
      @additional_cost.save!
      get :edit, { project_id: @project.id , id: @additional_cost.id }
    end
    subject { response }
    it { is_expected.to be_success }
  end

  describe "POST 'create'" do
    context 'when input correct data, ' do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: 'Additional', price: 10000, remarks: 'Remarks!' }}
      end
      describe 'check redirect path' do
        subject { response }
        it { is_expected.to redirect_to project_additional_costs_url(@project) }
      end
      describe 'check saved data' do
        subject { AdditionalCost.where(project_id: @project.id).first }

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq 'Additional' }
        end

        describe '#price' do
          subject { super().price }
          it { is_expected.to eq 10000 }
        end

        describe '#remarks' do
          subject { super().remarks }
          it { is_expected.to eq 'Remarks!' }
        end
      end
    end
    context 'when name is empty, ' do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: '', price: 10000 }}
      end
      describe 'check response template' do
        subject { response }
        it { is_expected.to render_template 'new' }
      end
    end
    context 'when price is empty, ' do
      before do
        post :create, {  project_id: @project.id, additional_cost:{ name: 'Additional', price: '' }}
      end
      describe 'check response template' do
        subject { response }
        it { is_expected.to render_template 'new' }
      end
    end
  end

  describe "POST 'upadte'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000, remarks: 'Remarks!')
      @additional_cost.save!
    end
    context 'when input correct data, ' do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: 'EditedAdditional', price: 20000, remarks: 'Updated Remarks!' }}
      end
      describe 'check redirect path' do
        subject { response }
        it { is_expected.to redirect_to project_additional_costs_url(@project) }
      end
      describe 'check saved data' do
        subject { AdditionalCost.where(project_id: @project.id).first }

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq 'EditedAdditional' }
        end

        describe '#price' do
          subject { super().price }
          it { is_expected.to eq 20000 }
        end

        describe '#remarks' do
          subject { super().remarks }
          it { is_expected.to eq 'Updated Remarks!' }
        end
      end
    end
    context 'when name is empty, ' do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: '', price: 20000 }}
      end
      describe 'check response template' do
        subject { response }
        it { is_expected.to render_template 'edit' }
      end
    end
    context 'when price is empty, ' do
      before do
        post :update, {  project_id: @project.id, id: @additional_cost.id, additional_cost:{ name: 'EditedAdditional', price: '' }}
      end
      describe 'check response template' do
        subject { response }
        it { is_expected.to render_template 'edit' }
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
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_additional_costs_url(@project) }
    end
    describe 'check deleted data' do
      subject { AdditionalCost.where(project_id: @project.id).size }
      it { is_expected.to eq 0 }
    end
  end

  describe "PATCH 'move_higher'" do
    before do
      @additional_cost1 = @project.additional_costs.build(name: 'Additional1', price: 10000)
      @additional_cost2 = @project.additional_costs.build(name: 'Additional2', price: 20000)
      @additional_cost1.save!
      @additional_cost2.save!
    end
    before do
      patch :move_higher, {  project_id: @project.id, id: @additional_cost2.id }
    end
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_additional_costs_url(@project) }
    end
    describe 'moved higher data' do
      subject { AdditionalCost.find(@additional_cost2.id).position }
      it { is_expected.to eq 1 }
    end
    describe 'moved lower data' do
      subject { AdditionalCost.find(@additional_cost1.id).position }
      it { is_expected.to eq 2 }
    end
  end

  describe "PATCH 'move_lower'" do
    before do
      @additional_cost1 = @project.additional_costs.build(name: 'Additional1', price: 10000)
      @additional_cost2 = @project.additional_costs.build(name: 'Additional2', price: 20000)
      @additional_cost1.save!
      @additional_cost2.save!
    end
    before do
      patch :move_lower, {  project_id: @project.id, id: @additional_cost1.id }
    end
    describe 'check redirect path' do
      subject { response }
      it { is_expected.to redirect_to project_additional_costs_url(@project) }
    end
    describe 'moved higher data' do
      subject { AdditionalCost.find(@additional_cost2.id).position }
      it { is_expected.to eq 1 }
    end
    describe 'moved lower data' do
      subject { AdditionalCost.find(@additional_cost1.id).position }
      it { is_expected.to eq 2 }
    end
  end
end
