class CopyItem
  include ActiveModel::Model
  attr_accessor :category_id, :sub_category_id, :type
  validates :type, presence: true
  with_options if: :sub_category? do |sub_category|
    sub_category.validates :category_id, presence: true
  end
  with_options if: :story? do |story|
    story.validates :category_id, presence: true
    story.validates :sub_category_id, presence: true
  end

  private

  def sub_category?
    self.type == 'sub_category'
  end

  def story?
    self.type == 'story'
  end
end
