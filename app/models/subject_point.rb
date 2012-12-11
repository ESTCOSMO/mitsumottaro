class SubjectPoint < ActiveRecord::Base
  attr_accessible :point_50, :point_90, :project_subject_id, :small_item_id
  belongs_to :small_item
  belongs_to :project_subject
end
