# Inventory tracking system for Fibers Home Store. 

# Create product records /
#  Edit product records //
#  Fetch and read product records  //
#  Delete product records //
#  Create / update / delete warehouse locations (and their descriptions) //
#  Assign products to a location (a given location should be able to hold multiple products) //
#  Move products from one location to another  //
#  Assign a product to a category //
#  Fetch all products in a given category //
#  Fetch all products in a given location //
#  Update product quantity //


# Empower my program with SQLite.
require "sqlite3"

require_relative "productclass.rb"
require_relative "locationclass.rb"
require_relative "categoryclass.rb"

# Load/create our database for this program in SQlite.
CONNECTION = SQLite3::Database.new("inventory.db")

# Create table for categories if not already exist.
CONNECTION.execute("CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY, name TEXT);")
# Create categories instance.

# Create table for locations if not already exist.
CONNECTION.execute("CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, name TEXT, address TEXT);")
# Create locations instance


# Make table for products if it doesn't already exist.
CONNECTION.execute("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, name TEXT, brand TEXT,
category_id INTEGER, quantity INTEGER, location_id INTEGER);")

# Get results as an Array of Hashes.
CONNECTION.results_as_hash = true




#------------------------------------------------------------------------------------------------------



# Main menu allows user to take several actions regarding products, locations and categories. 
puts "Welcome to Fiber's Product Inventory System!"
puts ""
puts "Please choose an action: (1) Add a product (2) Edit a product
(3) See all products (4) See all products in a category (5) See all products at store location 
(6) Edit store locations (0) Quit."
# Menu key.
menu = [1, 2, 3, 4, 5, 6, 0]

answer = gets.chomp.to_i

# While loop - If answer is not in menu key, prompt invalid menu option an ask user to input menu item again.
until menu.include?(answer)
  puts "Invalid menu action. Choose from:  (1) Add a product (2) Edit a product
  (3) See all products (4) See all products in a category (5) See all products at store location 
  (6) Edit store locations (0) Quit."
  answer = gets.chomp.to_i
end

# Action will loop until 0 entered.

while answer != 0 do
  # Case statement will choose case based on inputted action.
 
  # If user inputs 1, it will prompt to get information to create a product.  
  if answer == 1
    puts "Product name?"
    name = gets.chomp.capitalize.delete("'")
    
    puts "Product brand?"
    brand = gets.chomp.capitalize.delete("'")
    
    # Listing category id numbers from object array.
    # User then iputs correct category number.
    puts "Enter Category ID:?"
    Category.all.each do |category|
      puts "Category ID : #{category.id} - Name : #{category.name}"
    end
    category_id = gets.chomp.to_i
    # Must pick from valid category ids. 
    until Category.in_category.include?(category_id)
      puts "That's not a valid category. Enter category ID to see all products in category:"
      Category.all.each {|category| puts "Product ID : #{category.id} - Name : #{category.name}"}
      category_id = gets.chomp.to_i
    end
    
    # Enter quantity currently in stock for location.
    puts "Quantity in stock?"
    quantity = gets.chomp.to_i
    
    # Location Id for product. Each references one of three locations.
    puts "Enter Location ID:"
    Location.all.each do |location|
      puts "Location ID : #{location.id} - Name : #{location.name}"
    end
    location_id = gets.chomp.to_i
    # Must pick from valid locations. 
    until Location.in_location.include?(location_id)
      puts "That's not a valid location. Enter location ID to see all products in category:"
      Location.all.each {|location| puts "Location ID : #{location.id} - Name : #{location.name}"}
      location_id = gets.chomp.to_i
    end
    # Method to add new product details to products table in Products class. 
    # The add method also make a new product instance and generates key to make a
    # complete product object.
    
    # TODO change this to hash form. 
    Product.add({"name" => name, "brand" => brand, "category_id" => category_id, "quantity" => quantity, "location_id" => location_id})
    
    # Confirmation product has been added.
    puts "product added!"
    puts ""
    
    # Takes user back to main menu.
  end
  # If user inputted a 2, this is to edit an existing product.
  if answer == 2 # -----------This works in ORM for products so far. 
    # Iterate through each product in product objects (results to array) to show all products and details more clean. # This is no longer the table hash, this is the objects of the class.
    Product.all.each do |product|
      puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} -Category: #{product.category_id} - Quantity : #{product.quantity} - Location : #{product.location_id}"
    end
    # User chooses product by product ID number.
    puts "Enter product ID of product you would like to edit:"
    # Get product ID of product wanted to edit.
    product_id = gets.chomp.to_i
   
    # Finding product in table and making as object (instance in ruby in the method). Assigning object to instance variable so we can use instance methods on it. 
    instance = Product.find(product_id) #----------------------- using method to store instance in "instance"" 
    # Second menu prompt to ask what part of product to edit.
    puts "What would you like to edit on this product? (1) Edit name (2) Edit brand (3) Edit category ID 
    (4) Edit Location ID (5) Update product quantity (6) Delete this product (0) return to main menu."
    edit_menu = [1, 2, 3, 4, 5, 6, 0]
    edit = gets.chomp.to_i
    # If menu selection isn't apart of the edit_menu key, loop begins until user enters valid edit
    # menu item.
    until edit_menu.include?(edit)
      puts "Invalid entry. What would you like to edit on this product? (1) Edit name (2) Edit brand (3) Edit category ID 
      (4) Edit Location ID (5) Update product quantity (6) Delete this product (0) return to main menu."
      edit = gets.chomp.to_i
    end
    # If user input is a 1, program will prompt to update name of product.
    if edit == 1
      puts "What is the new name of product?"
      new_product_name = gets.chomp.capitalize.delete("'")
      # Create new instance of new product name with existing product ID.
      # Add new product name to products table with method from Products class.
      instance.name = new_product_name
      puts "name changed!"
      puts ""
      instance.save
    end
    
    
    # If user enters 2, edit brand name of product.
    if edit == 2
      puts "What is the new brand name?"
      new_brand = gets.chomp.capitalize.delete("'")
          
      # Add new product name to products table with method from Product class.
      instance.brand = new_brand
      puts "brand changed!"
      puts ""
      instance.save
    end
    # Edit category of product.
    if edit == 3
      puts "Enter new category ID:"
      # Iterates though object array to show categories and IDS. 
      Category.all.each do |category|
        puts "Product ID : #{category.id} - Name : #{category.name}"
      end
      new_category = gets.chomp.to_i
      # Update new product category to products table with method from Product class.
      instance.category_id = new_category
      puts "category changed!"
      puts ""
      instance.save
    end
    # Edit location of product.
    if edit == 4
      # Iterates through each location in location table(hash). Displays id # and name of location.
      puts "What is the new location id of product? Enter Location ID:"
      
      Location.all.each do |location|
        puts "Location ID : #{location.id} - Name : #{location.name}"
      end
      new_location_id = gets.chomp.to_i
        
      # Update location_id for products table with method from Product class.
      instance.location_id = new_location_id
      puts "location changed!"
      puts ""
      instance.save
    end
    # Update product quantity.
    if edit == 5
      puts "What is the current quantity of product? (number please)"
      new_quantity = gets.chomp.to_i
        
      # Update quantity for products table with method from Product class.
      instance.quantity = new_quantity
      puts "quantity updated!"
      puts ""
      instance.save
    end
    # Delete this product.
    if edit == 6
      # Check to make sure user wants to delete product
      puts "Are you sure you want to DELETE this product? Y or N"
      delete = gets.chomp.downcase
      if delete == "y"
        instance.delete_row
        puts "product deleted!"
        puts ""
        # If answer is n, takes user back to main menu.
      elsif delete == "n"
      else 
        puts "That is not a valid answer."
        # Returns them back to edit_menu if not entered correctly.
      end
      # End of edit product menu.
      if edit == 0
      end
      # else puts "That is not a valid answer."
      #       end 
    end
  end
  # See all products by location or category
  if answer == 3
    
    order_by = [1, 2, 3]

    puts "How would you like to see all products? (1) Sorted by Category or (2) Sorted by Location (3) Sorted by Quantity"
    order = gets.chomp.to_i

    until order_by.include?(order)
      puts " Invalid entry. How would you like to see all products? (1) Sorted by Category or (2) Sorted by Location?"
      order = gets.chomp.to_i
    end
    
    if order == 1
      
      Product.sort("category_id").each do |product|
        puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} - Category :  #{product.category_id} - Quantity: #{product.quantity} - Location: #{product.location_id}"
      end
    end
    
    if order == 2 
      
      Product.sort("location_id").each do |product|
        puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} - Category :  #{product.category_id} - Quantity: #{product.quantity} - Location: #{product.location_id}"
      end
    end
    
    if order == 3
      
      Product.sort("quantity").each do |product|
        puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} - Category :  #{product.category_id} - Quantity: #{product.quantity} - Location: #{product.location_id}"
      end
    end
    
  end


  # See all products in selected category -----------This works in ORM for products so far. 
  if answer == 4
    puts "Enter #category ID to see all products in category:"
    Category.all.each do |category|
      puts "Product ID : #{category.id} - Name : #{category.name}"
    end
    #  Store Category ID number they would like to see all products from.
    see_categories = gets.chomp.to_i
    # Checking to see if entered category number exists. 
    until Category.in_category.include?(see_categories)
      puts "That's not a valid category. Enter category ID to see all products in category:"
      Category.all.each {|category| puts "Product ID : #{category.id} - Name : #{category.name}"}
      see_categories = gets.chomp.to_i
    end
    # The find method - Finds category from table with catergory_id.
    # Then it creates an object in Category class. 
    # Set this equal to variable category_instance to use instance variables on. 
    category_instance = Category.find(see_categories)
    # Show Location store name using Locations method to display name.
    puts "All Products in #{category_instance.name}:"
    # Show all products at chosen location using method from Products class to show all products by category ID #.
    products_in_category = Product.where("category_id", see_categories) # This is now an array.
    # Iterating through object Array to dislay
    products_in_category.each do |product|   
      puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} -Category: #{product.category_id} - Quantity : #{product.quantity} - Location : #{product.location_id}"
    end
  end
  # See all products at store location.
  if answer == 5
    puts "Which store would you like to see all products? Enter Location ID:"
    # Iterate through locations table to show id # and name of stores. 
   
    Location.all.each do |location|
      puts "Location ID : #{location.id} - Name : #{location.name}"
    end
    # Store ID number they would like to see. 
    store_answer = gets.chomp.to_i
    # Creat new instance of Locations for store.
    store_instance = Location.find(store_answer)
    # Show Location store name using Locations method to display name. 
    puts "All Products at #{store_instance.name}:"
    # Show all products at chosen location using method from Products class to show all products by location ID #.
    stores = Product.where("location_id", store_answer)
    # Iterating through hash to dislay 
    stores.each do |product| 
      puts "Product ID : #{product.id} - Name : #{product.name} - Brand : #{product.brand} -Category: #{product.category_id} - Quantity : #{product.quantity} - Location : #{product.location_id}"
    end
  end

  if answer == 6
    # Edit store location menu.
    puts "Would you like to (1) Add a Store (2) Edit a store (3) Delete a store (4) Show all stores (0) back to main menu:"   
    store_change = gets.chomp.to_i
    store_menu = [1, 2, 3, 4, 0]
    until store_menu.include?(store_change)
      puts "Invalid entry. Would you like to (1) Add a Store (2) Edit a store (3) Delete a store (4) Show all stores (0) back to main menu:"   
      store_change = gets.chomp.to_i
    end
    # Add a store. 
    # User must add name of store and address. 
    if store_change == 1
      puts "Name of new store:"
      new_store_name = gets.chomp.capitalize
      puts "Address of new store:"
      store_address = gets.chomp
      #
      Location.add({"name" => new_store_name, "address" => store_address})
      # Success message letting user know store has been added. 
      puts "added!"
    end
    # Edit a store. 
    if store_change == 2
      puts "Which store would you like to edit?" 
      
      Location.all.each do |location|
        puts "Location ID : #{location.id} - Name : #{location.name}"
      end
      
      # Enter store ID to edit.
      store_edit = gets.chomp.to_i
      # Creating unique instance variable for this location_id.
      
      # Creating new instance with Location class for this store ID. Passing store ID through as 
      # argument for Intialization to Location class. 
      loc_instance = Location.find(store_edit)
      # Must update name and address.
      puts "Enter new store name:"
      edit_store_name = gets.chomp
      puts "Enter new store address:"
      edit_store_address = gets.chomp
      # Using method from Locations class to edit name and address of store.
      loc_instance.name = edit_store_name
      loc_instance.address = edit_store_address
      # Telling user changes have been made successfully.
      loc_instance.save
      puts "changed!"
    end
    
    # Delete a store. 
    if store_change == 3
      puts "Which store would you like to delete?" 
      # Iterating through all locations to show locations by ID and name.
      Location.all.each do |location|
        puts "Location ID : #{location.id} - Name : #{location.name} - Name : #{location.address}"
      end
      # Enter store ID to edit.
      store_delete = gets.chomp.to_i
      # Creating unique instance variable for this location_id.
     
      # Creating new instance with Location class for this store ID. Passing store ID through as 
      # argument for Intialization to Location class. 
      delete_instance = Location.find(store_delete)
      # Confirm user wants to delete store. 
      puts "Are you sure you want to DELETE this product? Y or N"
      delete_store = gets.chomp.downcase
      if delete == "y"
        delete_instance.delete_row
        puts "store deleted!"
        puts ""
      end
      # If answer is n, takes user back to main menu.
      if delete == "n"
      end
    end
    # Show all stores.
    if store_change == 4
      Location.all.each do |location|
        puts "Location ID : #{location.id} - Name : #{location.name}"
      end
    end
  end
  # Repeats back to main menu.
  puts "Choose an action: (1) Add a product (2) Edit a product
  (3) See all products (4) See all products in a category (5) See all products at store location 
  (6) Edit store locations (0) Quit."
  answer = gets.chomp.to_i
 
  # While loop - If answer is not in menu key, prompt invalid menu option an ask user to input menu item again.
  menu = [1, 2, 3, 4, 5, 6, 0]
  until menu.include?(answer)
    puts "Invalid menu action. Choose from:  (1) Add a product (2) Edit a product
    (3) See all products (4) See all products in a category (5) See all products at store location 
    (6) Edit store locations (0) Quit."
    answer = gets.chomp.to_i
  end
end