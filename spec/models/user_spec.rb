require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  describe "Associations" do
    # it { should belong_to(:bidder) }
    # it { should belong_to(:auction) }
  end

  describe "Validations" do
    # it { should validate_presence_of(:bidder) }
  end
end
