require 'spec_helper'

describe AdditionalCostsController do

  before do
    @project = Project.new(name: "Sample", days_per_point: 0.5)
    @project.save!
  end

  describe "GET 'index'" do
    before{ get 'index', { project_id: @project.id } }
    subject{ response }
    it{ should be_success }
  end

  describe "GET 'new'" do
    before{ get 'new', { project_id: @project.id } }
    subject{ response }
    it{ should be_success }
  end

  describe "GET 'edit'" do
    before do
      @additional_cost = @project.additional_costs.build(name: 'Additional', price: 10000)
      @additional_cost.save!
      get 'edit', { project_id: @project.id , id: @additional_cost.id }
    end
    subject{ response }
    it{ should be_success }
  end

end
