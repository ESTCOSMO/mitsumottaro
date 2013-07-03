class AddRemarksToSubCategories < ActiveRecord::Migration
  def change
    add_column :sub_categories, :remarks, :text
  end
end
