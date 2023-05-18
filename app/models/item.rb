class Item < ApplicationRecord
 
  validates :numero, presence: true, uniqueness: true
  paginates_per 8

  def generate_code
    GenBarcode.call(self)
  end  
end
