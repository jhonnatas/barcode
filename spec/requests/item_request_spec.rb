require 'rails_helper'

RSpec.describe "Item", type: :request do
  let(:valid_params) {
    attributes_for(:item) # creates a customer from factory and get it's hash attributes
  }

  let(:invalid_params) {
    { numero: nil, descricao: nil }
  }

  describe 'as logged in member' do 
    before(:each) do # creates before the examples then they can be used in each one of them
      @user = create(:user)
      @item = create(:item)
      sign_in(@user)
    end

    describe 'GET /index' do
      it 'returns http success' do
        get items_url 
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_item_url(@item)
        expect(response).to be_successful
      end
    end 

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new item' do
          expect {
            post items_url, params: { item: valid_params }
          }.to change(Item, :count).by(1)
        end

        it 'redirects to the created item' do
          post items_url, params: { item: valid_params }
          expect(response).to redirect_to(items_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Item' do
          expect {
            post items_url, params: { item: invalid_params}
          }.to change(Item, :count).by(0)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post items_url, params: { item: invalid_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        get edit_item_url(@item)
        expect(response).to be_successful
      end
    end
  end
end