# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Division.find_or_create_by(
  name: "PHP"
)

Division.find_or_create_by(
  name: "Ruby"
)

manager = User.find_or_create_by(
  name: "admin",
  email: "admin@sun-asterisk.com",
  role: :manager,
)

manager.update!(password: "123456", password_confirmation: "123456")
