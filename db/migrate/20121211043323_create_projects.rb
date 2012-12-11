class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.decimal :days_per_point

      t.timestamps
    end
  end
end
