class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :numero
      t.string :descricao

      t.timestamps
    end
  end
end
