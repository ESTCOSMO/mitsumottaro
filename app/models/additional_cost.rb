class AdditionalCost < ActiveRecord::Base
  belongs_to :project
  acts_as_list scope: :project
  validates :name, :price, presence: true
end
