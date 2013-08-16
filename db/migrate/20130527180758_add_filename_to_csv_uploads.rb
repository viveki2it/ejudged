class AddFilenameToCsvUploads < ActiveRecord::Migration
  def change
    add_column :csv_uploads, :filename, :string
  end
end
