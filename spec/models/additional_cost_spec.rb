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
      subject { AdditionalCost.new(name: " ") }
      it'has 1 error_on' do
        expect(subject.error_on(:name).size).to eq(1)
      end
    end

    context "when price is not present," do
      subject { AdditionalCost.new(price: " ") }
      it'has 1 error_on' do
        expect(subject.error_on(:price).size).to eq(1)
      end
    end

    context "when position is not present," do
      subject { AdditionalCost.new(position: " ") }
      it'does not have 1 error_on' do
        expect(subject.error_on(:position).size).not_to eq(1)
      end
    end
  end
end
