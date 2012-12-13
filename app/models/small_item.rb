class SmallItem < ActiveRecord::Base
  attr_accessible :medium_item_id, :name, :position
  belongs_to :medium_item
  acts_as_list scope: :medium_item
  has_many :subject_points, dependent: :destroy
  validates :name, presence: true
end
