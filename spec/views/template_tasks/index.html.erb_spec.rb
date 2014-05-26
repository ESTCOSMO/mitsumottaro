# coding: utf-8
require 'spec_helper'

describe "template_tasks/index" do
  before(:each) do
    assign(:template_tasks, [
      stub_model(TemplateTask,
        :name => "Name",
        :price_per_day => 10000
      ),
      stub_model(TemplateTask,
        :name => "Name",
        :price_per_day => 10000
      )
    ])
  end

  it "renders a list of template_tasks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name ↓", :count => 1
    assert_select "tr>td", :text => "Name ↑", :count => 1
    assert_select "tr>td", :text => "10,000", :count => 2
  end
end
