require 'spec_helper'

describe "template_tasks/edit" do
  before(:each) do
    @template_task = assign(:template_task, stub_model(TemplateTask,
      :name => "MyString",
      :position => 1
    ))
  end

  it "renders the edit template_task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => template_tasks_path(@template_task), :method => "post" do
      assert_select "input#template_task_name", :name => "template_task[name]"
      assert_select "input#template_task_position", :name => "template_task[position]"
    end
  end
end
