# -*- coding: utf-8 -*-
require 'spec_helper'

describe AdditionalCost do
  before { @addtional_cost = AdditionalCost.new }
  subject { @addtional_cost }

  it { should respond_to(:name) }
  it { should respond_to(:price) }
  it { should respond_to(:position) }

  describe "validation" do
    before { @addtional_cost = AdditionalCost.new(project_id: 1, name: '追加コスト', price: 100000, position: 1) }
    subject { @addtional_cost }
    it { should be_valid }

    context "when name is not present" do
      before { @addtional_cost.name = " " }
      it{ should_not be_valid }
    end

    context "when price is not present" do
      before { @addtional_cost.price = " " }
      it{ should_not be_valid }
    end

    context "when position is not present" do
      before { @addtional_cost.position = " " }
      it{ should be_valid }
    end
  end
end
