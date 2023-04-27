class ItemsController < ApplicationController
  require 'roo'

  before_action :authenticate_user!

  before_action :set_item, only: %i[show edit update destroy print_barcode]

  # GET /items or /items.json
  def index
    @items = Item.all.order('NUMERO').page params[:page]
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
        format.html { redirect_to items_path success: 'Item foi criado com sucesso.' }
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
        format.html { redirect_to items_path, success: 'Item foi atualizado com sucesso.' }
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
      format.html { redirect_to items_url, success: 'Item foi deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  def del_all
    if Item.any? 
      Item.destroy_all
      redirect_to items_url, success: 'Os itens foram deletados.' 
    else  
      redirect_to items_url, info: 'Não há itens cadastrados.' 
    end     
  end

  # Calls generate_code method and prints the barcode.
  def print_barcode
    @item.generate_code
    redirect_to request.referer # back to the same page
  end

  def import
    import = ImportItemCSV.new(file: params[:file]) # file is send by form
    import.run!
    if import.report.success?
      redirect_to items_path, success: 'Arquivo importado com sucesso!'
    else
      redirect_to items_path, success: "Não foi possível importar o arquivo: #{import.report.message}"
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:numero, :descricao)
  end
end
