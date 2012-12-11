class SmallItem < ActiveRecord::Base
  attr_accessible :medium_item_id, :name, :position
  belongs_to :medium_item
  has_many :subject_points, dependent: :destroy
end
