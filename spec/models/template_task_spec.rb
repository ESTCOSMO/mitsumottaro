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
      subject { TemplateTask.new(name: " ") }
      it'has 1 error_on' do
        expect(subject.error_on(:name).size).to eq(1)
      end
    end
    context "when price_per_day is not present," do
      subject { TemplateTask.new(price_per_day: " ") }
      it'has 1 error_on' do
        expect(subject.error_on(:price_per_day).size).to eq(1)
      end
    end
    context "when position is not present," do
      subject { TemplateTask.new(position: " ") }
      it'does not have 1 error_on' do
        expect(subject.error_on(:position).size).not_to eq(1)
      end
    end
    context "when default_task is not present," do
      subject { TemplateTask.new(default_task: " ") }
      it'does not have 1 error_on' do
        expect(subject.error_on(:default_task).size).not_to eq(1)
      end
    end
  end
end
