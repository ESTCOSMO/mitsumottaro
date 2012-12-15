require 'spec_helper'

describe "template_tasks/show" do
  before(:each) do
    @template_task = assign(:template_task, stub_model(TemplateTask,
      :name => "Name",
      :position => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
