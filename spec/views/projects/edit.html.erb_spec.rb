require 'spec_helper'

describe "projects/edit", :type => :view do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :days_per_point => "9.99"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_days_per_point", :name => "project[days_per_point]"
    end
  end
end
