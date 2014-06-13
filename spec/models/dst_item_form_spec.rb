# -*- coding: utf-8 -*-
require 'spec_helper'

describe DstItemForm, :type => :model do
  describe "field definitions" do
    subject { DstItemForm.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:category_id) }
    it { is_expected.to respond_to(:sub_category_id) }
  end

  describe "validation" do
    context "when type is empty," do
      subject { DstItemForm.new(name: 'name') }
      it'has 1 error_on' do
        expect(subject.error_on(:type).size).to eq(1)
      end
    end
    context "when name is empty," do
      subject { DstItemForm.new(type: 'category') }
      it'has 1 error_on' do
        expect(subject.error_on(:name).size).to eq(1)
      end
    end
    context "when type is cagetory," do
      context "when category_id and sub_category_id are empty," do
        subject { DstItemForm.new(name: 'name', type: 'category') }
        it { is_expected.to be_valid }
      end
    end
    context "when type is sub_cagetory," do
      context "when category_id and sub_category_id are empty," do
        subject { DstItemForm.new(name: 'name', type: 'sub_category') }
        it'has 1 error_on' do
          expect(subject.error_on(:category_id).size).to eq(1)
        end
      end
    end
    context "when type is story," do
      context "when category_id is empty," do
        subject { DstItemForm.new(name: 'name', type: 'story', sub_category_id: 1) }
        it'has 1 error_on' do
          expect(subject.error_on(:category_id).size).to eq(1)
        end
      end
      context "when sub_category_id is empty," do
        subject { DstItemForm.new(name: 'name', type: 'story', category_id: 1) }
        it'has 1 error_on' do
          expect(subject.error_on(:sub_category_id).size).to eq(1)
        end
      end
    end
  end
end
