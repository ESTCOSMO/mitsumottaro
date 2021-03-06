require 'spec_helper'

describe Api::TaskPointsController, :type => :controller do
  before do
    @project = Project.create(name: 'Project', days_per_point: 1.0 )
    @project_task = @project.project_tasks.build(name: 'ProjectTask', price_per_day: 40000)
    @category = @project.categories.build(name: 'Category')
    @sub_category = @category.sub_categories.build(name: 'SubCategory')
    @story = @sub_category.stories.build(name: 'Story')
    @project.save!
  end
  describe "xhr POST 'create':" do
    context 'when task_point does not exists,' do
      context 'when point parameters are blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: '', point_90: '' }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }
          it{ is_expected.to be_nil }
        end
      end
      context 'when both point parameters are not blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: 3, point_90: 8 }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to eq 3 }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to eq 8 }
          end
        end
      end
      context 'when point_50 parameter is blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: '', point_90: 8 }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to be_nil }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to eq 8 }
          end
        end
      end
      context 'when point_90 parameter is blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: 11, point_90: '' }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to eq 11 }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to be_nil }
          end
        end
      end
      context 'when some parameters are invalid,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: 'xx', point_90: 8 }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] }
        end
      end
    end
    context 'when task_point exists,' do
      before do
        @story.task_points.build(project_task_id: @project_task.id, point_50: 1, point_90: 3)
        @story.save!
      end
      context 'when point parameters are blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: '', point_90: '' }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }
          it{ is_expected.to be_nil }
        end
      end
      context 'when both point parameters are not blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: 3, point_90: 8 }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to eq 3 }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to eq 8 }
          end
        end
      end
      context 'when point_50 parameter is blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: '', point_90: 8 }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to be_nil }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to eq 8 }
          end
        end
      end
      context 'when point_90 parameter is blank,' do
        before do
          xhr :post, :create, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, point_50: 11, point_90: '' }
        end
        describe 'response status' do
          subject{ response.status }
          it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
        end
        describe 'saved data' do
          subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }

          describe '#point_50' do
            subject { super().point_50 }
            it { is_expected.to eq 11 }
          end

          describe '#point_90' do
            subject { super().point_90 }
            it { is_expected.to be_nil }
          end
        end
      end
    end
  end
  describe "xhr DELETE 'destroy':" do
    before do
      @task_point = @story.task_points.build(project_task_id: @project_task.id, point_50: 1, point_90: 3)
      @story.save!
      xhr :delete, :destroy, { project_id: @project.id, category_id: @category.id, sub_category_id: @sub_category.id, story_id: @story.id, project_task_id: @project_task.id, id: @task_point.id }
    end
    describe 'response status' do
      subject{ response.status }
      it{ is_expected.to eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe 'deleted data' do
      subject{ TaskPoint.where(story_id: @story.id, project_task_id: @project_task.id).first }
      it{ is_expected.to be_nil }
    end
  end
end
