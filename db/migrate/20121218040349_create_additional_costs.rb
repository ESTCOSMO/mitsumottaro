class CreateAdditionalCosts < ActiveRecord::Migration
  def change
    create_table :additional_costs do |t|
      t.integer :project_id
      t.string :name
      t.integer :price
      t.integer :position

      t.timestamps
    end
  end
end
