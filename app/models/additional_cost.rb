class AdditionalCost < ActiveRecord::Base
  attr_accessible :name, :position, :price, :project_id
  belongs_to :project
  acts_as_list scope: :project
  validates :name, :price, presence: true
end
