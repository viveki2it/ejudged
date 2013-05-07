class CreateRoles < ActiveRecord::Migration
	def change
		create_table :roles do |t|
		  t.string :RoleName

		  t.timestamps
		end
		# Role.create  :RoleName => "Administrator"
		# Role.create  :RoleName => "Event Manager"
		# Role.create  :RoleName => "Judge"
	end
end
