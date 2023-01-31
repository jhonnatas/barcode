require 'roo'
namespace :import do
  desc "Importando dados do arquivo"
  task data: :environment do
    puts 'Importando dados do aquivo'

    data = Roo::Spreadsheet.open('lib/data.xlsx') # open spreadsheet
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
      puts "Salvando item com número: '#{item.numero}'"
      item.save!
    end
  end
end
