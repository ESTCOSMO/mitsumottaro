class AddPricePerDayToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :price_per_day, :integer
  end
end
