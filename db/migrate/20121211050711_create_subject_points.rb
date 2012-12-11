class CreateSubjectPoints < ActiveRecord::Migration
  def change
    create_table :subject_points do |t|
      t.integer :small_item_id
      t.integer :project_subject_id
      t.integer :point_50
      t.integer :point_90

      t.timestamps
    end
  end
end
