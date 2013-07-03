class AddRemarksToStories < ActiveRecord::Migration
  def change
    add_column :stories, :remarks, :text
  end
end
