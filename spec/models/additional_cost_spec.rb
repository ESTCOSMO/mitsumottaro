# -*- coding: utf-8 -*-
require 'spec_helper'

describe AdditionalCost do
  describe "field definitions" do
    subject { AdditionalCost.new }
    it { should respond_to(:name) }
    it { should respond_to(:price) }
    it { should respond_to(:position) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { AdditionalCost.new(project_id: 1, name: "追加コスト", price: 100000, position: 1) }
      it { should be_valid }
    end

    context "when name is not present," do
      subject { AdditionalCost.new(name: " ") }
      it{ should have(1).error_on(:name) }
    end

    context "when price is not present," do
      subject { AdditionalCost.new(price: " ") }
      it{ should have(1).error_on(:price) }
    end

    context "when position is not present," do
      subject { AdditionalCost.new(position: " ") }
      it{ should_not have(1).error_on(:position) }
    end
  end
end
