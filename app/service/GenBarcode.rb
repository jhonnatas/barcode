class GenBarcode < ApplicationService
	attr_reader :item
	
  def initialize(item)
    @item = item
  end

	def call
		# build_label
		label = build_label

		image1 = get_image_1
		image2 = get_image_2
		
		barcode1 = left_barcode(@item.numero)
		barcode2 = right_barcode(@item.numero)	

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
		print_job.print label, ip, print_service: 'rlpr' # pra isso funcionar, tem que configurar o lpd no windows 
	end

	def build_label
		Zebra::Zpl::Label.new(
			width:        800, #width of the barcode image on the label
			length:       30,
			print_speed:  3
		)			
	end

	def get_image_1
		#image1 = Zebra::Zpl::Image.new(
		Zebra::Zpl::Image.new(
			path: "#{Rails.root}/public/ifce.png",
			position: [82, 40],
			width: 305,
			height: 65
		)
	end
	
	def get_image_2
		#image2 = Zebra::Zpl::Image.new(
		Zebra::Zpl::Image.new(
			path: "#{Rails.root}/public/ifce.png",
			position: [525, 40],
			width: 305,
			height: 65
		)
	end

	def left_barcode(tipping_number)
		Zebra::Zpl::Barcode.new(
			data:                       tipping_number,
			position:                   [85, 110], # x, y
			height:                     70,
			print_human_readable_code:  true,
			narrow_bar_width:           2,
			wide_bar_width:             8,
			type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
		)
	end

	def right_barcode(tipping_number)
		Zebra::Zpl::Barcode.new(
			data:                       tipping_number,
			position:                   [525, 110],
			height:                     70,
			print_human_readable_code:  true,
			narrow_bar_width:           2,
			wide_bar_width:             8,
			type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
		)
	end
end
