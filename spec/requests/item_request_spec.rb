# frozen_string_literal: true
require 'rails_helper'
require 'csv'
require 'ImportItemCSV'

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

    # describe 'GET /print_barcode' do
    #   xit 'redirects to items page' do
    #     get print_barcode_item_url(@item), headers: { "HTTP_REFERER" => items_path }
    #     expect(response).to redirect_to items_path
    #   end
    # end

    describe 'GET /del_all' do
      it 'deletes all items from db' do
        get del_all_url
        expect(Item.count).to eq(0)
      end
    end

    describe 'GET /del_all' do
      it 'shows Não há itens cadastrados when no items saved on db' do
        Item.destroy_all
        get del_all_url
        expect(flash[:info]).to match(/Não há itens cadastrados/)
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

    it 'creates items by importing a valid csv file' do 
      file = "#{Rails.root}/public/item_data.csv"
        CSV.open(file, 'wb', col_sep: ';', headers: true) do |csv|
          csv << %w[numero descricao]
          csv << [@item.numero, @item.descricao]
        end

        import = ImportItemCSV.new(path: file)
        import.run!
        expect(import.report.success?).to be true
    end

    it 'fails when importing a csv file without number information' do 
      file = "#{Rails.root}/public/item_data.csv"
        CSV.open(file, 'wb', col_sep: ';', headers: true) do |csv|
          csv << %w[descricao]
          csv << [@item.descricao]
        end

        import = ImportItemCSV.new(path: file)
        import.run!
        expect(import.report.success?).to be false
    end
  end
end