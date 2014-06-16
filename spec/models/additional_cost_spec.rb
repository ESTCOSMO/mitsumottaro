# -*- coding: utf-8 -*-
require 'spec_helper'

describe AdditionalCost, :type => :model do
  describe "field definitions" do
    subject { AdditionalCost.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:price) }
    it { is_expected.to respond_to(:position) }
  end

  describe "validation" do
    context "when input valid data," do
      subject { AdditionalCost.new(project_id: 1, name: "追加コスト", price: 100000, position: 1) }
      it { is_expected.to be_valid }
    end

    context "when name is not present," do
      subject { AdditionalCost.new(name: " ").tap(&:valid?).errors[:name].size }
      it { is_expected.to eq 1 }
    end

    context "when price is not present," do
      subject { AdditionalCost.new(price: " ").tap(&:valid?).errors[:price].size }
      it { is_expected.to eq 1 }
    end

    context "when position is not present," do
      subject { AdditionalCost.new(position: " ").tap(&:valid?).errors[:position].size }
      it { is_expected.to be 0 }
    end
  end
end
