class GenBarcode < ApplicationService
attr_reader :item
	
  def initialize(item)
    @item = item
  end

	def call
		# build_label
		label = build_label

		image1 = get_image('ifce.png', 82, 40, 305, 65)
		image2 = get_image('ifce.png', 525, 40, 305, 65)
		
		barcode1 = draw_barcode(@item.numero, 85, 110, 70)
		barcode2 = draw_barcode(@item.numero, 525, 110, 70)	

		# Set image background to white
		src = image1.source
		src.background('white').flatten

		src = image2.source
		src.background('white').flatten

		label << image1
		label << image2
		label << barcode1
		label << barcode2

		send_to_printer(label, '10.30.1.24')
	end

	private

	def send_to_printer(label, ip)
		print_job = Zebra::PrintJob.new 'zebra'
		print_job.print label, ip, print_service: 'rlpr' # To get this working setup lpd for windows.
	end

	def build_label
		Zebra::Zpl::Label.new(
			width:        800, # total width of the two barcodes image side by side on the label
			length:       30,
			print_speed:  3
		)			
	end

	def get_image(file_name, pos_x, pos_y, width, height)
		Zebra::Zpl::Image.new(
			path: "#{Rails.root}/public/#{ file_name }",
			position: [pos_x, pos_y],
			width: width,
			height: height
		)
	end

	def draw_barcode(tipping_number, pos_x, pos_y, height)
		Zebra::Zpl::Barcode.new(
			data:                       tipping_number,
			position:                   [pos_x, pos_y], # x, y
			height:                     height,
			print_human_readable_code:  true,
			narrow_bar_width:           2,
			wide_bar_width:             8,
			type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
		)
	end
end
