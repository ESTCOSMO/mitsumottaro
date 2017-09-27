require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DashboardsHelper. For example:
#
# describe DashboardsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe DashboardsHelper, :type => :helper do
  describe "make_anchor method" do
    context "when sub_category_id is null & story_id is null," do
      subject{ helper.make_anchor(1, nil, nil) }
      it{ is_expected.to eq "category1" }
    end
    context "when sub_category_id is not null & story_id is null," do
      subject{ helper.make_anchor(1, 2, nil) }
      it{ is_expected.to eq "sub_category1-2" }
    end
    context "when sub_category_id is not null & story_id is not null," do
      subject{ helper.make_anchor(1, 2, 3) }
      it{ is_expected.to eq "story1-2-3" }
    end
  end
  describe "up_arrow_link_to_unless method" do
    let(:project){ Project.create(name:"Project")}
    let(:category){ Category.create(project_id: project.id, name:"Category")}
    let(:sub_category){ SubCategory.create(category_id: category.id, name:"SubCategory")}
    let(:story){ Story.create(sub_category_id: sub_category.id, name: "Story") }
    let(:icon){ "<i class='icon-arrow-up'></i>" }
    context "when condition is true, " do
      subject{ helper.up_arrow_link_to_unless(true, { }) }
      it{ is_expected.to be_nil }
    end
    context "when sub_category is not present and story is not present, " do
      before do
        @name = helper.make_anchor(category.id)
        @path = move_higher_project_category_path(project, category)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject{ helper.up_arrow_link_to_unless(false, { project: project, category: category }) }
      it{ is_expected.to eq @expected }
    end
    context "when sub_category is present and story is not present, " do
      before do
        @name = helper.make_anchor(category.id, sub_category.id)
        @path = move_higher_project_category_sub_category_path(project, category, sub_category)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject do
        helper.up_arrow_link_to_unless(false, { project: project, category: category, sub_category: sub_category })
      end
      it{ is_expected.to eq @expected }
    end
    context "when sub_category is present and story is present, " do
      before do
        @name = helper.make_anchor(category.id, sub_category.id, story.id)
        @path = move_higher_project_category_sub_category_story_path(project, category, sub_category, story)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject do
        helper.up_arrow_link_to_unless(false, { project: project, category: category, sub_category: sub_category, story: story })
      end
      it{ is_expected.to eq @expected }
    end
  end
  describe "down_arrow_link_to_unless method" do
    let(:project){ Project.create(name:"Project")}
    let(:category){ Category.create(project_id: project.id, name:"Category")}
    let(:sub_category){ SubCategory.create(category_id: category.id, name:"SubCategory")}
    let(:story){ Story.create(sub_category_id: sub_category.id, name: "Story") }
    let(:icon){ "<i class='icon-arrow-down'></i>" }
    context "when condition is true, " do
      subject{ helper.down_arrow_link_to_unless(true, { }) }
      it{ is_expected.to be_nil }
    end
    context "when sub_category is not present and story is not present, " do
      before do
        @name = helper.make_anchor(category.id)
        @path = move_lower_project_category_path(project, category)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject{ helper.down_arrow_link_to_unless(false, { project: project, category: category }) }
      it{ is_expected.to eq @expected }
    end
    context "when sub_category is present and story is not present, " do
      before do
        @name = helper.make_anchor(category.id, sub_category.id)
        @path = move_lower_project_category_sub_category_path(project, category, sub_category)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject do
        helper.down_arrow_link_to_unless(false, { project: project, category: category, sub_category: sub_category })
      end
      it{ is_expected.to eq @expected }
    end
    context "when sub_category is present and story is present, " do
      before do
        @name = helper.make_anchor(category.id, sub_category.id, story.id)
        @path = move_lower_project_category_sub_category_story_path(project, category, sub_category, story)
        @expected = "<a name=\"#{@name}\" class=\"arrow\" style=\"color:silver\" href=\"#{@path}\">#{icon}</a>"
      end
      subject do
        helper.down_arrow_link_to_unless(false, { project: project, category: category, sub_category: sub_category, story: story })
      end
      it{ is_expected.to eq @expected }
    end
  end
end
