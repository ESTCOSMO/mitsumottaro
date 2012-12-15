class ChangeItemsTableNames < ActiveRecord::Migration
  def change
    rename_column :small_items, :medium_item_id, :sub_category_id
    rename_column :medium_items, :large_item_id, :category_id
    rename_column :subject_points, :small_item_id, :story_id
    rename_table :large_items, :categories
    rename_table :medium_items, :sub_categories
    rename_table :small_items, :stories
  end
end
