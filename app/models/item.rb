class Item < ApplicationRecord
  #has_one_attached :barcode
  validates :numero, uniqueness: true
  #validates :file, presence: true

  #after_create :generate_code
  
  #def generate_code
  #  GenerateBarcode.call(self)
  #end
  
  def generate_code
    GenBarcode.call(self)
  end
  
end
