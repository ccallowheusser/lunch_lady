require 'pry'
require_relative 'Lunch_item'

# instantiate lunch items, m = main dish, s = side dish, e = extras
# main dishes
@main = []
@main.push Lunch_item.new('Meatloaf', 'main', 4.99, "Better-than-your-mother's meat loaf", 844, 56, 60)
@main.push Lunch_item.new('Veggie burger', 'main', 8.55, "Tastes like buffalo without killing the animal", 525, 12, 78)
@main.push Lunch_item.new('Fried chicken', 'main', 6.19, "Home cooked, finger lickin' good!", 1058, 60, 52)
@main.push Lunch_item.new('Pulled pork', 'main', 4.99, "A taste of Hawaii", 660, 24, 49)

# side dishes
@sides = []
@sides.push Lunch_item.new('Cooked carrots', 'side', 0.89, "Get your eye-strengthening beta-carotene!", 40, 2, 5)
@sides.push Lunch_item.new('Applesauce', 'side', 1.29, "Apples with a touch of cinnamon and nutmeg", 52, 0, 13)
@sides.push Lunch_item.new('Green beans', 'side', 1.19, "Clean your plate...green beans make you healthy!", 48, 1, 9)
@sides.push Lunch_item.new('Ranch-style beans', 'side', 0.99, "Beans, beans, the magical fruit!", 126, 3, 18)
@sides.push Lunch_item.new('Garlic Mashed potatoes', 'side', 2.29, "LOTS of garlic--Don't breathe on anyone!", 238, 11, 32)

# extra items
@extras = []
@extras.push Lunch_item.new('Sliced apples', 'extra', 0.79, "An apple a day keeps mom away!", 60, 0, 15)
@extras.push Lunch_item.new('Bread and butter', 'extra', 1.59, "What's a meal without bread and butter?", 260, 13, 30)
@extras.push Lunch_item.new('Carrot cake', 'extra', 3.29, "Mmmmm-Mmmmm, cream cheese frosting!", 930, 48, 111)
@extras.push Lunch_item.new("Apple pie 'n ice cream", 'extra', 3.99, "American as Applie Pie!", 740, 20, 128)
@extras.push Lunch_item.new('Iced tea', 'extra', 1.59, "Your zero-calorie thirst quencher", 10, 0, 0)
@extras.push Lunch_item.new('Hefeweizen', 'extra', 5.59, "Is it 5:00 yet? It is in Germany!", 400, 0, 100)
@extras.push Lunch_item.new('Water', 'extra', 0.10, "Remember, 8 glasses a day!", 0, 0, 0)

# prints food descriptions, gets passed an array of class instances for menu items: main, sides, or extras
def print_descriptions(menu)
	menu.each_with_index { |menu, index| puts "\t#{index + 1}) #{menu.item}: #{menu.description}\n\n"}
end

# starts over with the order process
def clear
	order_meals(@main, @side, @extra)
end

# prints order, gets passed an array of instances of class lunch_item
def print_order(order)
	puts "Here are the items you've ordered:"
	order.each {|food| puts "#{food.item}: $#{food.price}\n\tcalories: #{food.calories}\tfat: #{food.fat} g\tcarbs: #{food.carbs} g"}
end

# checks to make sure a response is a valid dollar amount
# returns the dollar amount as a float
def get_dollar_amount
	puts "What is the maximum dollar amount you want to spend?"
	amt = gets.strip
	if amt =~ /\A[0-9]*\.?[0-9][0-9]\Z/
		puts "You have $#{amt} to spend.\n\n"
		amt.to_f
	else
		puts "Invalid dollar amount.\n\n"
		get_dollar_amount
	end
end

# gets the maximum amount of money user wants to spend on lunch as float
def get_max(amt)
	puts "Do you want to set a limit on your lunch price? Y or N"
	@response = gets.strip.downcase
	case @response
	when 'y', 'yes'
		get_dollar_amount
	when 'n','no'	
		nil
	else
		puts "Invalid input. Enter Y or N."
		get_max(amt)
	end
end

# gets an item from the specified menu section: main, sides, extras
# gets passed a string stype telling part of menu: main, sides, extras
# menu as an array of class instances of type lunch_item
# the amount of money in the wallet (nil or a float)
# the amount of money already spent
def get_item(stype, menu, wallet, spent)
	# ask user to make a choice from menu items
	puts "Enter the number of the #{stype} dish would you like, d for descriptions, c for clear, or q to quit."
	menu.each_with_index { |menu, index| puts "\t#{index + 1}) #{menu.item}: $#{menu.price}"}
	@choice = gets.strip

	# if valid choice as menu item number
	if (@choice =~ /\A\d\Z/) && (@choice.to_i <= menu.length)

		# if wallet is nil, no limit to spending, don't worry how much has been spent
		# return menu choice as instantiation of class lunch item
		if wallet == nil
			menu[@choice.to_i - 1]

		# if wallet has max amount to spend on lunch, make sure item prices is less than amount remaining
		# return menu choice as instantiation of class lunch item
		elsif menu[@choice.to_i - 1].price < (wallet - spent)
			menu[@choice.to_i - 1]
		else
			# let user know they don't have that much to spend and ask for another item
			puts "That item costs more than the amount remaining in your wallet."
			puts "Amount remaining: $#{(wallet - spent).round(2)}\n\n"
			get_item(stype, menu, wallet, spent)
		end
		
	# print descritions of items and get another item
	elsif @choice.downcase == 'd'
		print_descriptions(menu)
		get_item(stype, menu, wallet, spent)

	# quit getting items 
	elsif @choice.downcase == 'q'
		nil

	elsif @choice.downcase == 'c'
		clear

	else
		# input not valid, get another item
		puts "INVALID INPUT.\n\n"
		get_item(stype, menu, wallet, spent)
	end
end

# prints single item and amount spent
def print_item(item, spent)
	puts "You added #{item.item} to your order."
	puts "You've spent $#{(spent).round(2)}\n\n"
end

# builds order of 1 main dish, 2 side dishes, and unlimited extras
# if user set maximum wallet amount, doesn't allow ordering beyond wallet amount
# returns array of [order, spent]
def order_items(order, main, sides, extras, wallet, spent)
	# set looping value until order complete
	continue = true

	# get one item from main menu
	item = get_item("main", main, wallet, spent)
	if item
		order.push item
		spent = spent + order.last.price
		print_item(item, spent)
	end

	# get one item from side menu
	item = get_item("side", sides, wallet, spent)
	if item
		order.push item
		spent = spent + order.last.price
		print_item(item, spent)
	end

	# get another item from side menu
	item = get_item("side", sides, wallet, spent)
	if item
		order.push item
		spent = spent + order.last.price
		print_item(item, spent)
	end

	# get extras until user says they're done
	while continue
		puts "Do you want to order extra items? Y or N"
		response = gets.strip
		case response.downcase
		when 'y', 'yes'
			item = get_item("extra", extras, wallet, spent)
			if item
				order.push item
				spent = spent + order.last.price
				print_item(item, spent)
			else
				continue = false
			end
		when 'n', 'no'
			continue = false
		else
			puts "INVALID INPUT.\n\n"
		end
	end

	# return array with order which is an array of instantiations of class lunch item
	# and amount spent
	[order, spent]
end

# loop to order one or more meals
# input arrays of class instantiations for meal items: 
# @main, @sides and @extras
def order_meals(main, sides, extras)
	# set loop value
	order_again = true

	# now loop 
	while order_again
		# set initial values
		order = []
		meal = nil
		wallet = nil
		spent = 0.0

		# get amount in wallet
		wallet = get_max(wallet)

		# build order, get array with order, spent back.
		order = order_items(order, main, sides, extras, wallet, spent)
		meal = order[0]
		spent = order[1]
		puts "\n\nYour lunch order will cost $#{spent.round(2)}."
		if wallet
			puts "You have $#{(wallet - spent).round(2)} left.\n"
		end
		print_order(meal)

		# decide if getting another order
		puts "\n\nDo you want to order another lunch? Y or N"
		resp = gets.strip
		case resp.downcase
		when 'y', 'yes'
			order_again = true
		else
			order_again = false
		end
	end
end

# get this show on the road!
order_meals(@main, @sides, @extras)

