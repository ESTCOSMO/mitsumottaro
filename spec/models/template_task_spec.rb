# -*- coding: utf-8 -*-
require 'spec_helper'

describe TemplateTask do
  before { @template_task = TemplateTask.new(name: "要件定義", price_per_day: 50000, position: 3) }
  subject { @template_task }

  it { should respond_to(:name) }
  it { should respond_to(:position) }
  it { should respond_to(:price_per_day) }

  it { should be_valid }

  describe "when name is not present" do
    before { @template_task.name = " " }
    it{ should_not be_valid }
  end

  describe "when price_per_day is not present" do
    before { @template_task.price_per_day = "" }
    it{ should_not be_valid }
  end

  describe "when position is not present" do
    before { @template_task.position = "" }
    it{ should be_valid }
  end
end
