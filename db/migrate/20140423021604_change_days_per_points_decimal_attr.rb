class ChangeDaysPerPointsDecimalAttr < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.change :days_per_point, :decimal, precision: 10, scale: 2
    end
  end
end
