require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  let(:<%= singular_table_name %>) { FactoryGirl.create(:<%= singular_table_name %>) }

  it "has a valid factory" do
    expect(<%= singular_table_name %>).to be_valid
  end

  describe "Associations" do
    # it { should belong_to(:bidder) }
    # it { should belong_to(:auction) }
  end

  describe "Validations" do
    # it { should validate_presence_of(:bidder) }
  end
end
<% end -%>