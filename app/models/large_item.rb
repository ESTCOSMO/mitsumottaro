class LargeItem < ActiveRecord::Base
  attr_accessible :name, :position, :project_id
  belongs_to :project
  has_many :medium_items, dependent: :destroy
  validates :name, presence: true
end
