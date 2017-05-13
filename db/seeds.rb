require 'open-uri'
require 'json'

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

print 'fetching cocktails url.....'
cocktails_url = 'http://www.thecocktaildb.com/api/json/v1/1/filter.php?c=cocktail'

print 'creating cocktails JSON string.....'
cocktails_string = open(cocktails_url).read

print 'parsing cocktails JSON string.....'
cocktails_data = JSON.parse(cocktails_string)

print 'seeding cocktails'
cocktails_details = []
cocktails_data['drinks'].each do |cocktail_data|
  cocktail_url = 'http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=' + cocktail_data['idDrink']
  cocktail_details = open(cocktail_url).read
  cocktail_datas = JSON.parse(cocktail_details)
  cocktails_details << cocktail_datas
  cocktail = Cocktail.new(name: cocktail_data['strDrink'])
  cocktail.photo_url = cocktail_data['strDrinkThumb'] unless cocktail_data['strDrinkThumb'].nil?
  category_data = cocktail_datas['drinks'][0]['strAlcoholic']
  cocktail.category = category_data
  instructions_data = cocktail_datas['drinks'][0]['strInstructions']
  cocktail.instructions = instructions_data
  cocktail.save!
  print '.'
end

print 'fetching ingredients url.....'
ingredients_url = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'

print 'creating ingredients JSON string.....'
ingredients_string = open(ingredients_url).read

print 'parsing ingredients JSON string.....'
ingredients_data = JSON.parse(ingredients_string)

print 'seeding ingredients'
ingredients_data['drinks'].each do |ingredient_data|
  Ingredient.create!(name: ingredient_data['strIngredient1'])
  print '.'
end

print 'doses....'
cocktails_details.each do |cocktail_details|
  cocktail = Cocktail.find_by_name(cocktail_details['drinks'][0]['strDrink'])
  (1..15).each do |i|
    ingredient_data = cocktail_details['drinks'][0]["strIngredient#{i}"]
    dose_desc = cocktail_details['drinks'][0]["strMeasure#{i}"]
    if dose_desc.nil? || dose_desc.empty? || dose_desc == " " || dose_desc == "\n"
      dose_desc = '1'
    end
    if ingredient_data.nil?
      ingredient_data = ""
    end
    unless ingredient_data.empty?
      ingredient = Ingredient.find_by_name(ingredient_data)
      if ingredient.nil?
        ingredient = Ingredient.new(name: ingredient_data)
        ingredient.save!
      end
      Dose.create!(description: dose_desc, ingredient: ingredient, cocktail: cocktail)
      print "dose #{i} for #{cocktail.name}..."
    end
  end
end
puts 'done !'
