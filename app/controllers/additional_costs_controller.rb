class AdditionalCostsController < ApplicationController
  before_filter :set_project_to_variable
  def index
    @additional_costs = @project.additional_costs
  end

  def new
    @additional_cost = @project.additional_costs.build
  end

  def edit
    @additional_cost = @project.additional_costs.find params[:id]
  end

  def create
    @additional_cost = @project.additional_costs.build(permitted_params_for_additional_cost)
    @additional_cost.save!
    redirect_to project_additional_costs_url(@project)
  rescue ActiveRecord::RecordInvalid => e
    render 'new'
  end

  def update
    @additional_cost = @project.additional_costs.find params[:id]
    @additional_cost.update_attributes!(permitted_params_for_additional_cost)
    redirect_to project_additional_costs_url(@project)
  rescue ActiveRecord::RecordInvalid => e
    render 'edit'
  end

  def destroy
    @project.additional_costs.find(params[:id]).destroy
    redirect_to project_additional_costs_url(@project)
  end

  private
  def set_project_to_variable
    @project = Project.find(params[:project_id])
  end

  def permitted_params_for_additional_cost
    params.require(:additional_cost).permit(:name, :price)
  end
end
