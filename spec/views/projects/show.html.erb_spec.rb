require 'spec_helper'

describe 'projects/show', :type => :view do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => 'Name',
      :days_per_point => '9.99'
    ))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/9.99/)
  end
end
