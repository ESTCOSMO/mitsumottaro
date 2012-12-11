class CreateMediumItems < ActiveRecord::Migration
  def change
    create_table :medium_items do |t|
      t.integer :large_item_id
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
