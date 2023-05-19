class Item < ApplicationRecord
 
  validates :numero, presence: true, uniqueness: true, numericality: { only_integer: true }
  paginates_per 8

  def generate_code
    GenBarcode.call(self)
  end  
end
