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
				
			barcode = Zebra::Zpl::Barcode.new(
				#data:                       '12345678',
				data:                       @item.numero,
				position:                   [85, 73],
				height:                     100,
				print_human_readable_code:  true,
				narrow_bar_width:           2,
				wide_bar_width:             8,
				type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
			)
				
			label << barcode
			
			print_job = Zebra::PrintJob.new 'zebra'
			
			ip = '10.30.1.24'  # can use 'localhost', '127.0.0.1', or '0.0.0.0' for local machine
			
			#print_job.print label, ip
			print_job.print label, ip, print_service: 'rlpr' # pra isso funcionar, tem que configurar o lpd no windows 
    end

    
  end
  