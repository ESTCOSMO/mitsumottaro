# -*- coding: utf-8 -*-
require 'spec_helper'

describe DstItemForm do
  describe "field definitions" do
    subject { DstItemForm.new }
    it { should respond_to(:name) }
    it { should respond_to(:type) }
    it { should respond_to(:category_id) }
    it { should respond_to(:sub_category_id) }
  end

  describe "validation" do
    context "when type is empty," do
      subject { DstItemForm.new(name: 'name') }
      it{ should have(1).error_on(:type) }
    end
    context "when name is empty," do
      subject { DstItemForm.new(type: 'category') }
      it{ should have(1).error_on(:name) }
    end
    context "when type is cagetory," do
      context "when category_id and sub_category_id are empty," do
        subject { DstItemForm.new(name: 'name', type: 'category') }
        it { should be_valid }
      end
    end
    context "when type is sub_cagetory," do
      context "when category_id and sub_category_id are empty," do
        subject { DstItemForm.new(name: 'name', type: 'sub_category') }
        it{ should have(1).error_on(:category_id) }
      end
    end
    context "when type is story," do
      context "when category_id is empty," do
        subject { DstItemForm.new(name: 'name', type: 'story', sub_category_id: 1) }
        it{ should have(1).error_on(:category_id) }
      end
      context "when sub_category_id is empty," do
        subject { DstItemForm.new(name: 'name', type: 'story', category_id: 1) }
        it{ should have(1).error_on(:sub_category_id) }
      end
    end
  end
end
