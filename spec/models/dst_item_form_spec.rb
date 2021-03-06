# -*- coding: utf-8 -*-
require 'spec_helper'

describe DstItemForm, :type => :model do
  describe 'field definitions' do
    subject { DstItemForm.new }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:category_id) }
    it { is_expected.to respond_to(:sub_category_id) }
  end

  describe 'validation' do
    context 'when type is empty,' do
      subject { DstItemForm.new(name: 'name').tap(&:valid?).errors[:type].size }
      it { is_expected.to eq 1 }
    end
    context 'when name is empty,' do
      subject { DstItemForm.new(type: 'category').tap(&:valid?).errors[:name].size }
      it { is_expected.to eq 1 }
    end
    context 'when type is cagetory,' do
      context 'when category_id and sub_category_id are empty,' do
        subject { DstItemForm.new(name: 'name', type: 'category') }
        it { is_expected.to be_valid }
      end
    end
    context 'when type is sub_cagetory,' do
      context 'when category_id and sub_category_id are empty,' do
        subject { DstItemForm.new(name: 'name', type: 'sub_category').tap(&:valid?).errors[:category_id].size }
        it { is_expected.to eq 1 }
      end
    end
    context 'when type is story,' do
      context 'when category_id is empty,' do
        subject { DstItemForm.new(name: 'name', type: 'story', sub_category_id: 1).tap(&:valid?).errors[:category_id].size }
        it { is_expected.to eq 1 }
      end
      context 'when sub_category_id is empty,' do
        subject { DstItemForm.new(name: 'name', type: 'story', category_id: 1).tap(&:valid?).errors[:sub_category_id].size }
        it { is_expected.to eq 1 }
      end
    end
  end
end
