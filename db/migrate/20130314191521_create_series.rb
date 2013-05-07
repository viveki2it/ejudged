class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :SeriesName
      t.boolean :Completed

      t.timestamps
    end
  end
end
