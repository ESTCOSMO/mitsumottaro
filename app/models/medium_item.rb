class MediumItem < ActiveRecord::Base
  attr_accessible :large_item_id, :name, :position
  belongs_to :large_item
  has_many :small_items, dependent: :destroy
  validates :name, presence: true

  def count_of_small_items
    small_items.size
  end
end
