class CreateCsvUploads < ActiveRecord::Migration
  def change
    create_table :csv_uploads do |t|
      t.string :Type
      t.references :company

      t.timestamps
    end
    add_index :csv_uploads, :company_id
  end
end
