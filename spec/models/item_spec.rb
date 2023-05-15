require 'rails_helper'

RSpec.describe Item, type: :model do
  context 'when creating an item' do
    it 'is valid with name and description' do
      item = create(:item)
      expect(item).to be_valid
    end

    it 'is invalid without numero' do
      item = build(:item, numero: nil)
      expect(item).not_to be_valid
    end
  end
end