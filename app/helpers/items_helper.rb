module ItemsHelper
  def item_form_for obj, &block
    if obj.is_a? LargeItem
      form_for [obj.project, obj], &block
    elsif obj.is_a? MediumItem
      form_for [obj.large_item.project, obj.large_item, obj], &block
    else
      form_for [obj.medium_item.large_item.project, obj.medium_item.large_item, obj.medium_item, obj], &block
    end
  end
end
