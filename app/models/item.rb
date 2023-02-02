class Item < ApplicationRecord
  has_one_attached :barcode

  after_create :generate_code
  
  #def generate_code
  #  GenerateBarcode.call(self)
  #end
  
  def self.generate_code
    GenBarcode.call(self)
  end
end
