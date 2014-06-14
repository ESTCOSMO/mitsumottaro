# -*- coding: utf-8 -*-
require 'spec_helper'

describe TemplateTask, :type => :model do
  describe "field definitions" do
    subject { TemplateTask.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:price_per_day) }
    it { is_expected.to respond_to(:default_task) }
  end
  describe "validation" do
    context "when input valid data," do
      subject { TemplateTask.new(name: "要件定義", price_per_day: 50000, position: 3, default_task: false) }
      it { is_expected.to be_valid }
    end
    context "when name is not present," do
      subject { TemplateTask.new(name: " ").tap(&:valid?).errors[:name].size }
      it { is_expected.to eq 1 }
    end
    context "when price_per_day is not present," do
      subject { TemplateTask.new(price_per_day: " ").tap(&:valid?).errors[:price_per_day].size }
      it { is_expected.to eq 1 }
    end
    context "when position is not present," do
      subject { TemplateTask.new(position: " ").tap(&:valid?).errors[:position].size }
      it { is_expected.to eq 0 }
    end
    context "when default_task is not present," do
      subject { TemplateTask.new(default_task: " ").tap(&:valid?).errors[:default_task].size }
      it { is_expected.to eq 0 }
    end
  end
end
