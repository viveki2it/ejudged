class AddCompanyIdToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :company_id, :integer
  end
end
