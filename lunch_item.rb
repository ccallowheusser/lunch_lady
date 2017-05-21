class Lunch_item
	# Make sure properties are gettable and settable
	attr_accessor :item, :item_type, :price, :description, :calories, :fat, :carbs 

	# initialize properties
	def initialize(item, item_type, price, description, calories, fat, carbs)
		@item = item
		@item_type = item_type
		@price = price
		@description = description
		@calories = calories
		@fat = fat
		@carbs = carbs
	end

# instance methods
# none yet

# class method cannot be called by instances, only on class
# none yet
# def self.name_of_method
# end

end