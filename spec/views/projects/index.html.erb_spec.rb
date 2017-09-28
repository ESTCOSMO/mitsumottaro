require 'spec_helper'

describe 'projects/index', :type => :view do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => 'Name',
        :days_per_point => '9.99',
        :created_at => Time.zone.parse('2014/03/03 10:00:00')
      ),
      stub_model(Project,
        :name => 'Name',
        :days_per_point => '9.99',
        :created_at => Time.zone.parse('2014/03/03 10:00:00')
      )
    ])
  end

  it 'renders a list of projects' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'tr>td', :text => 'Name'.to_s, :count => 2
    assert_select 'tr>td', :text => '9.99'.to_s, :count => 2
    assert_select 'tr>td', :text => '2014/03/03 10:00:00'.to_s, :count => 2
  end
end
