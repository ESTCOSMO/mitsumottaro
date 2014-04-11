# -*- coding: utf-8 -*-
require 'spec_helper'

describe TemplateTask do
  describe "field definitions" do
    subject { TemplateTask.new }
    it { should respond_to(:name) }
    it { should respond_to(:position) }
    it { should respond_to(:price_per_day) }
  end
  describe "validation" do
    context "when input valid data," do
      subject { TemplateTask.new(name: "要件定義", price_per_day: 50000, position: 3) }
      it { should be_valid }
    end
    context "when name is not present," do
      subject { TemplateTask.new(name: " ") }
      it{ should have(1).error_on(:name) }
    end
    context "when price_per_day is not present," do
      subject { TemplateTask.new(price_per_day: " ") }
      it{ should have(1).error_on(:price_per_day) }
    end
    context "when position is not present," do
      subject { TemplateTask.new(position: " ") }
      it{ should_not have(1).error_on(:position) }
    end
  end
end
