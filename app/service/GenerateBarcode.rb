class GenerateBarcode < ApplicationService
    attr_reader :item
  
    def initialize(item)
      @item = item
    end
  
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/ascii_outputter'
    require 'barby/outputter/png_outputter'
  
    def call
      barcode = Barby::Code128B.new(item.numero)
  
      # chunky_png required for THIS action
      png = Barby::PngOutputter.new(barcode).to_png
  
      #image_name = SecureRandom.hex
      image_name = item.numero
  
      #IO.binwrite("tmp/#{image_name}.png", png.to_s)
      IO.binwrite("public/barcode/#{image_name}.png", png.to_s)
  
      blob = ActiveStorage::Blob.create_and_upload!(
        #io: File.open("tmp/#{image_name}.png"),
        io: File.open("public/barcode/#{image_name}.png"),
        filename: image_name,
        content_type: 'png'
      )
  
      item.barcode.attach(blob)
    end
  end
  