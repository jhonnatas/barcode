class AddPrintedToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :printed, :boolean, default: false
  end
end
