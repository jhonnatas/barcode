class Item < ApplicationRecord
 
  validates :numero, uniqueness: true
  
  paginates_per 18

  def generate_code
    GenBarcode.call(self)
  end
  
end
