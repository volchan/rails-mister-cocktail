# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Destroying cocktails !'
Cocktail.destroy_all
puts 'cocktails anihilated !'
puts '-' * 20
puts 'Destroying ingredients !'
Ingredient.destroy_all
puts 'ingredients anihilated !'
puts '-' * 20
puts 'Destroying doses !'
Dose.destroy_all
puts 'doses anihilated !'
puts '-' * 20

puts 'THEY SEE ME SEEDING...'

print 'cocktails'
10.times do
  Cocktail.create!(name: Faker::Ancient.titan)
  print '.'
end

print 'ingredients'
20.times do
  Ingredient.create!(name: Faker::Food.ingredient)
  print '.'
end

print 'doses'
Cocktail.all.each do |cocktail|
  Dose.create!(description: Faker::Lorem.paragraph, cocktail: cocktail, ingredient: Ingredient.all.sample)
  print '.'
end

puts 'done !'
