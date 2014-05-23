class AddDefaultToTemplateTasks < ActiveRecord::Migration
  def change
    add_column :template_tasks, :default_task, :boolean
  end
end
