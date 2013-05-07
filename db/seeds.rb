# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Creating default roles
require 'role.rb'
require 'question_type.rb'
require 'club.rb'

if (Role.all.size == 0 )
	Role.create(:RoleName => "Administrator")
	Role.create(:RoleName => "Event Manager")
	Role.create(:RoleName => "Judge")
end
if (QuestionType.all.size == 0)
	QuestionType.create(:Type => "Slider")
	QuestionType.create(:Type => "Circles")
	QuestionType.create(:Type => "Stars")
	QuestionType.create(:Type => "Notes")
end
if (Club.all.size == 0)
	Club.create(:ClubName => "N/A")
end
