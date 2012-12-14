class AddPricePerDayAndNameToProjectSubjects < ActiveRecord::Migration
  def change
    add_column :project_subjects, :name, :string
    add_column :project_subjects, :price_per_day, :integer
  end
end
