class CreateSmallItems < ActiveRecord::Migration
  def change
    create_table :small_items do |t|
      t.integer :medium_item_id
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
