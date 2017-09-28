require 'spec_helper'

describe TaskPoint, :type => :model do
  describe 'field definitions' do
    subject { TaskPoint.new }
    it { is_expected.to respond_to(:project_task_id) }
    it { is_expected.to respond_to(:point_50) }
    it { is_expected.to respond_to(:point_90) }
  end

  describe 'validation' do
    context 'when input valid data,' do
      subject { TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 50) }
      it { is_expected.to be_valid }
    end
    context 'when project_task_id is not present,' do
      subject { TaskPoint.new(project_task_id: ' ').tap(&:valid?).errors[:project_task_id].size }
      it { is_expected.to eq 1 }
    end
    context 'when point_50 is not numeric,' do
      subject { TaskPoint.new(point_50: 'abc') }
      it{ is_expected.not_to be_valid }
    end
    context 'when point_50 is not integer,' do
      subject { TaskPoint.new(point_50: 14.5) }
      it{ is_expected.not_to be_valid }
    end
    context 'when point_90 is not numeric,' do
      subject { TaskPoint.new(point_90: 'abc') }
      it{ is_expected.not_to be_valid }
    end
    context 'when point_90 is not integer,' do
      subject { TaskPoint.new(point_90: 8.5) }
      it{ is_expected.not_to be_valid }
    end
  end

  describe 'square_of_diff method' do
    context 'both points is not empty,' do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ is_expected.to eq 625 }
    end
    context 'point_50 is empty,' do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_90: 45) }
      subject { @task_point.square_of_diff }
      it{ is_expected.to eq 0 }
    end
    context 'point_90 is empty,' do
      before { @task_point = TaskPoint.new(story_id: 1, project_task_id: 1, point_50: 20) }
      subject { @task_point.square_of_diff }
      it{ is_expected.to eq 0 }
    end
  end
end
