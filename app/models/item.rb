class Item < ApplicationRecord
 
  validates :numero, presence: true, uniqueness: true
  paginates_per 10

  def generate_code
    GenBarcode.call(self)
  end  
end
