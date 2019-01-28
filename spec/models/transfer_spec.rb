require 'rails_helper'

RSpec.describe Transfer, type: :model do
  let(:transfer) { FactoryGirl.create(:transfer) }

  it "has a valid factory" do
    expect(transfer).to be_valid
  end

  describe "Associations" do
    # it { should belong_to(:bidder) }
    # it { should belong_to(:auction) }
  end

  describe "Validations" do
    # it { should validate_presence_of(:bidder) }
  end
end
