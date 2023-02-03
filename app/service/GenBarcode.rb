class GenBarcode < ApplicationService
    attr_reader :item
  
    def initialize(item)
      @item = item
    end
  
    def call
			label = Zebra::Zpl::Label.new(
				width:        800, #width of the barcode image on the label
				length:       30,
				print_speed:  3
			)				

			image1 = Zebra::Zpl::Image.new(
				path: "#{Rails.root}/public/ifce.png",
				position: [82, 40],
				width: 305,
				height: 65
			)

			image2 = Zebra::Zpl::Image.new(
				path: "#{Rails.root}/public/ifce.png",
				position: [525, 40],
				width: 305,
				height: 65
			)
				
			barcode1 = Zebra::Zpl::Barcode.new(
				data:                       @item.numero,
				position:                   [85, 110], # x, y
				height:                     70,
				print_human_readable_code:  true,
				narrow_bar_width:           2,
				wide_bar_width:             8,
				type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
			)
			barcode2 = Zebra::Zpl::Barcode.new(
				data:                       @item.numero,
				position:                   [525, 110],
				height:                     70,
				print_human_readable_code:  true,
				narrow_bar_width:           2,
				wide_bar_width:             8,
				type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
			)

			# Set image background to white
			src = image1.source
			src.background('white').flatten

			src = image2.source
			src.background('white').flatten

			label << image1
			label << image2
			label << barcode1
			label << barcode2
			
			print_job = Zebra::PrintJob.new 'zebra'
			
			ip = '10.30.1.24'  # can use 'localhost', '127.0.0.1', or '0.0.0.0' for local machine
			
			#print_job.print label, ip
			print_job.print label, ip, print_service: 'rlpr' # pra isso funcionar, tem que configurar o lpd no windows 
    end
    
  end
  