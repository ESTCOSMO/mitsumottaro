class CreateProjectSubjects < ActiveRecord::Migration
  def change
    create_table :project_subjects do |t|
      t.integer :project_id
      t.integer :subject_id
      t.integer :position

      t.timestamps
    end
  end
end
