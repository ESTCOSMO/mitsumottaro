require 'spec_helper'

describe "template_tasks/new" do
  before(:each) do
    assign(:template_task, stub_model(TemplateTask).as_new_record)
  end

  it "renders new template_task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => template_tasks_path, :method => "post" do
      assert_select "input#template_task_name", :name => "template_task[name]"
      assert_select "input#template_task_price_per_day", :name => "template_task[price_per_day]"
    end
  end
end
