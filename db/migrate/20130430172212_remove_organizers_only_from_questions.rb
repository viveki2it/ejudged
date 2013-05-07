class RemoveOrganizersOnlyFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :OrganizersOnly
  end

  def down
    add_column :questions, :OrganizersOnly, :boolean
  end
end
