class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :FirstName, :limit => 64
      t.string :LastName, :limit => 64
      t.string :MiddleInitial, :limit => 64
      t.string :Address1, :limit => 128
      t.string :Address2, :limit => 128
      t.string :Address3, :limit => 128
      t.string :State, :limit => 32
      t.string :ZipCode, :limit => 32
      t.string :Phone, :limit => 32
      t.string :AltPhone, :limit => 32
      t.string :Email, :limit => 128
      t.string :City, :limit => 32

      t.timestamps
    end
  end
end
