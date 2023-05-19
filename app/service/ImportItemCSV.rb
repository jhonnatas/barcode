class ImportItemCSV
  include CSVImporter

  model Item

  # Maps the csv columns to attributes
  column :numero, required: true
  column :descricao, required: true

  identifier :numero
end