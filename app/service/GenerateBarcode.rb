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
    build_barcode(@item.numero)
  end

  private

  def build_barcode(tipping_number)
    barcode = Barby::Code128B.new(tipping_number)

    # chunky_png required for THIS action
    png = Barby::PngOutputter.new(barcode).to_png(margin: 3, height: 25)

    image_name = item.numero

    IO.binwrite("app/assets/images/#{image_name}.png", png.to_s)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open("app/assets/images/#{image_name}.png"),
      filename: image_name,
      content_type: 'png'
    )
    item.barcode.attach(blob)
  end
end
