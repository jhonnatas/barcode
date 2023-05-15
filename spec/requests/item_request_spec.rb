require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      @user = create(:user)
      sign_in(@user)
      get items_url 
      expect(response).to be_successful
    end
  end
end
