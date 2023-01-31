class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles do |t|
      t.integer :number

      t.timestamps
    end
  end
end
