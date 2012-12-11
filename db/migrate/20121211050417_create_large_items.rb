class CreateLargeItems < ActiveRecord::Migration
  def change
    create_table :large_items do |t|
      t.integer :project_id
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
