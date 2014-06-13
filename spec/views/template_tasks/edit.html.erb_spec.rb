require 'spec_helper'

describe "template_tasks/edit", :type => :view do
  before(:each) do
    @template_task = assign(:template_task, stub_model(TemplateTask,
      :name => "MyString",
      :price_per_day => 50000
    ))
  end

  it "renders the edit template_task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => template_tasks_path(@template_task), :method => "post" do
      assert_select "input#template_task_name", :name => "template_task[name]", :value => "MyString"
      assert_select "input#template_task_price_per_day", :name => "template_task[price_per_day]", :value => 50000
    end
  end
end
