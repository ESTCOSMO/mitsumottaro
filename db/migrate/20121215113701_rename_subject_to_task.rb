class RenameSubjectToTask < ActiveRecord::Migration
  def change
    rename_column :subject_points, :project_subject_id, :project_task_id
    rename_column :project_subjects, :subject_id, :template_task_id
    rename_table :subjects, :template_tasks
    rename_table :project_subjects, :project_tasks
    rename_table :subject_points, :task_points
  end
end
