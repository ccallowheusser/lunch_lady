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
@side = []
@side.push Lunch_item.new('Cooked carrots', 'side', 0.89, "Get your eye-strengthening beta-carotene!", 40, 2, 5)
@side.push Lunch_item.new('Applesauce', 'side', 1.29, "Apples with a touch of cinnamon and nutmeg", 52, 0, 13)
@side.push Lunch_item.new('Green beans', 'side', 1.19, "Clean your plate...green beans make you healthy!", 48, 1, 9)
@side.push Lunch_item.new('Ranch-style beans', 'side', 0.99, "Beans, beans, the magical fruit!", 126, 3, 18)
@side.push Lunch_item.new('Garlic Mashed potatoes', 'side', 2.29, "LOTS of garlic--Don't breathe on anyone!", 238, 11, 32)

# extra items
@extra = []
@extra.push Lunch_item.new('Sliced apples', 'extra', 0.79, "An apple a day keeps mom away!", 60, 0, 15)
@extra.push Lunch_item.new('Bread and butter', 'extra', 1.59, "What's a meal without bread and butter?", 260, 13, 30)
@extra.push Lunch_item.new('Carrot cake', 'extra', 3.29, "Mmmmm-Mmmmm, cream cheese frosting!", 930, 48, 111)
@extra.push Lunch_item.new("Apple pie 'n ice cream", 'extra', 3.99, "American as Applie Pie!", 740, 20, 128)
@extra.push Lunch_item.new('Iced tea', 'extra', 1.59, "Your zero-calorie thirst quencher", 10, 0, 0)
@extra.push Lunch_item.new('Hefeweizen', 'extra', 5.59, "Is it 5:00 yet? It is in Germany!", 400, 0, 100)
@extra.push Lunch_item.new('Water', 'extra', 0.10, "Remember, 8 glasses a day!", 0, 0, 0)

# set amount in wallet to a default high amount
@wallet = 999.99

# start with an empty order
@order = []

def view_description(order)

end

def display_total(order)

end

def clear(order)
	@order = []
	order_lunch(@order)
end

def print_lunch

end

# gets the maximum amount of money user wants to spend on lunch
def get_max(amt)
	puts "Do you want to set a limit on your lunch price? Y or N"
	@response = gets.strip.downcase
	if @response.downcase == 'y' || @response.downcase == 'yes'
		puts "What is the maximum dollar amount you want to spend?"
		amt = gets.strip
		if amt =~ /\A[0-9]*\.?[0-9][0-9]\Z/
			puts "You have $#{amt} to spend.\n\n"
			amt.to_f
		else
			puts "Invalid dollar amount.\n\n"
			get_max(@wallet)
		end
	elsif @response.downcase == 'n' || @response.downcase == 'no'	
		@wallet
	else
		puts "Invalid input. Enter Y or N."
		get_max(amt)
	end
end

def get_item(stype, type, amt)
	puts "Enter the number of the #{stype} dish would you like, d for descriptions, or q to quit."
	type.each_with_index { |type, index| puts "\t#{index + 1}) #{type.item}: $#{type.price}"}
	@choice = gets.strip

	
	if @choice =~ /\A\d\Z/ 
		if @choice.to_i <= type.length
			if type[@choice.to_i - 1].price < amt
				type[@choice.to_i - 1]
			else
				puts "That item costs more than the amount remaining in your wallet. Amount remaining: $#{amt.round(2)}"
				get_item(stype, type, amt)
			end
		else
			puts "Invalid input."
		end
		
	elsif @choice.downcase == 'd'
		type.each_with_index { |type, index| puts "\t#{index + 1}) #{type.item}: #{type.description}\n\n"}
		get_item(stype, type, amt)

	elsif @choice.downcase == 'q'
		nil

	else
		puts "Invalid input."
		get_item(stype, type, amt)
	end
end

def order_lunch(main, side, extra, amt)
	@continue = true
	item = get_item("main", main, amt)
	if item
		@order.push item
		amt = amt - @order.last.price
		puts "You added #{item.item} to your order."
		puts "You've spent $#{(@wallet - amt).round(2)}\n\n"
	end

	item = get_item("side", side, amt)
	if item
		@order.push item
		amt = amt - @order.last.price
		puts "You added #{item.item} to your order."
		puts "You've spent $#{(@wallet - amt).round(2)}\n\n"
	end

	item = get_item("side", side, amt)
	if item
		@order.push item
		amt = amt - @order.last.price
		puts "You added #{item.item} to your order."
		puts "You've spent $#{(@wallet - amt).round(2)}\n\n"
	end

	while @continue
		puts "Do you want to order extra items? Y or N"
			@response = gets.strip
			if @response.downcase == 'y' || @response.downcase == 'yes'
				item = get_item("extra", extra, amt)
				if item
					@order.push item
					amt = amt - @order.last.price
					puts "You added #{item.item} to your order."
					puts "You've spent $#{(@wallet - amt).round(2)}\n\n"
				else
					@continue = false
				end
			elsif @response.downcase == 'n' || @response.downcase == 'no'
				@continue = false
			else
				puts "Invalid input."
			end
	end
	puts "\n\nYour lunch order will cost $#{(@wallet - amt).round(2)}."
	puts "You have $#{amt.round(2)} left.\n"
	puts "Here are the items you've ordered:"
	@order.each {|food| puts "#{food.item}: $#{food.price}\n\tcalories: #{food.calories}\tfat: #{food.fat} g\tcarbs: #{food.carbs} g"}
end

@wallet = get_max(@wallet)
order_lunch(@main, @side, @extra, @wallet)



