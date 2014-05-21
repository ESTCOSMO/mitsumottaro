class AddRemarksToAdditionalCosts < ActiveRecord::Migration
  def change
    add_column :additional_costs, :remarks, :text
  end
end
