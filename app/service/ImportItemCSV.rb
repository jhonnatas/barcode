class ImportItemCSV
    include CSVImporter

    model Item

    column :numero, required: true
    column :descricao, required: true
  end