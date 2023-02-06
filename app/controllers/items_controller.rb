class ItemsController < ApplicationController
  require 'roo'

  before_action :set_item, only: %i[ show edit update destroy print_barcode ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def del_all
    if Item.any? 
      Item.delete_all
      redirect_to items_url, notice: "Os itens foram deletados." 
    else  
      redirect_to items_url, notice: "Não há itens cadastrados" 
    end     
  end

   # Calls generate_code method and prints the barcode.
  def print_barcode
    @item = Item.find(params[:id]) # I don't know why set_item method didn't get the object from db.
    @item.generate_code
    redirect_to items_path
  end

  def import
    #data = Roo::Spreadsheet.open('lib/data.xlsx') # open spreadsheet
    data = Roo::Spreadsheet.open(params[:file]) # open spreadsheet
    headers = data.row(1) # get header row

    data.each_with_index do |row, idx|
      next if idx == 0 # skip header row
      # create hash from headers and cells
      item_data = Hash[[headers, row].transpose]
      # next if item exists
      if Item.exists?(numero: item_data['numero'])
        puts "Item com o número #{item_data['numero']} já existe"
        next
      end
      
      item = Item.new(item_data)
      item.save!
    end
    redirect_to items_path, notice: 'Arquivo importado com sucesso!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end   

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:numero, :descricao)
    end

end
