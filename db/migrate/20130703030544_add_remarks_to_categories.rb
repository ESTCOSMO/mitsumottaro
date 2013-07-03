class AddRemarksToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :remarks, :text
  end
end
