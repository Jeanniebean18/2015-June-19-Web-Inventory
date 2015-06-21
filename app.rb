require "pry"
require "sinatra"
require "sinatra/reloader"
# Inventory tracking system for Fibers Home Store. 
# Empower my program with SQLite.
require "sqlite3"
require "active_support/inflector"


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

require_relative "productclass.rb"
require_relative "locationclass.rb"
require_relative "categoryclass.rb"

#------------------------------------------------------------------------------------------------------
# ########################### BEGIN WEB UX ############################

get "/home" do
  erb :homemenu
  # This would be where your menu is with a erb menu file with pretty HTML. right?
end

get "/add_product" do
  erb :"add_product"
end

get "/save_product" do
  # Since the form's action was "/save_student", it sent its values here.
  #
  # Sinatra stores them for us in `params`, which is a hash. Like this:
  #
  # {"name" => "Beth", "age" => "588"}
  
  # So using `params`, we can run our class/instance methods as needed
  # to create a student record.

  Product.add({"name" => params["name"], "brand" => params["brand"], "category_id" => params["category_id"].to_i, "quantity" => params["quantity"].to_i, "location_id" => params["location_id"].to_i})
  erb :"product_added"
end
get "/edit_products" do
  erb :"products" # Where the edit form lives.
end

get "/edit_save/" do
  @product_instance = Product.find(params["id"])
  @product_instance.name = params["name"]
  @product_instance.brand = params["brand"]
  @product_instance.category_id = params["category_id"].to_i
  @product_instance.quantity = params["quantity"].to_i
  @product_instance.location_id = params["location_id"].to_i
  @product_instance.save
  erb :edit_success
end

  
 
  
  
  # if params["edit"] == "brand"
  #   # new erb file with edit name field.
  #   @product_instance.brand = params["value_edited"]
  # elsif params["edit"] == "category_id"
  #   # new erb file with edit name field.
  #   @product_instance.category_id = params["value_edited"].to_i
  # elsif params["edit"] == "quantity"
  #   # new erb file with edit name field.
  #   @product_instance.quantity = params["value_edited"].to_i
  # elsif params["edit"] == "location_id"
  #   # new erb file with edit name field.
  #   @product_instance.location_id = params["value_edited"].to_i
  # end
  # @product_instance.save
  # erb :"edit_product" # This is the success message.
# end

# get "/edit_success/" do
# @product_instance.name = params["name"]



get "/see_products" do
  erb :"see_products" # lists all products
end

# get "/see_product/:x/name" do
#   @product_instance = Product.find(params["x"])
#   @product_instance.params["edit"] = params["text"]
#   @product_instance.save

# end

get "/products_category" do
  erb :"product_category"
  
end

get "/see_category/:x" do
  # `params` stores information from BOTH the path (:x) and from the
  # form's submitted information. So right now,
  # `params` is {"x" => "3", "name" => "Marlene"}
  @category_instance = Category.find(params["x"])
  @products_in_category = Product.where("category_id", params["x"])
  erb :"see_products_in_category"

  # TODO - Send the user somewhere nice after they successfully
  # accomplish this name change.
  # TODO how to make the edit list dynamic?
  # TODO if fields are blank, say try again - sumeet had this in his tutorial. basically is name is nil, don't continue the step to add to database?
  # add location edit - should be easier than product won't require a dynamic form I don't think. 
  # 
end


