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

# home menu with add product, edit product, see all products, see all products in category, see all products
# location and edit store options. 

get "/home" do
  erb :homemenu
end
# add product form. 
# Returns form params to save product path.
get "/add_product" do
  erb :"add_product"
end
# Recieves product params from add product form.
#
# Adds product to products table as long as "name" is not empty.
# if name is empty, asks them to try again.
#
# .add adds to database and to Product object.
#
# Returns success page if name is not empty.
get "/save_product" do
  if params["name"].empty?
    "Sorry name cannot be empty try again."
    # add erb file here to return to edit page.
  else 
  Product.add({"name" => params["name"], "brand" => params["brand"], "category_id" => params["category_id"].to_i, "quantity" => params["quantity"].to_i, "location_id" => params["location_id"].to_i})
  erb :"product_added"
end
end
# edit_products path displays an edit form for product.
get "/edit_products" do
  erb :"products" # Where the edit form lives.
end

get "/edit_save/" do
  @product_instance = Product.find(params["id"])
  if !params["name"].empty?
  @product_instance.name = params["name"]
end
if !params["brand"].empty?
  @product_instance.brand = params["brand"]
end
if !params["category_id"].empty?
  @product_instance.category_id = params["category_id"].to_i
end
if !params["quantity"].empty?
  @product_instance.quantity = params["quantity"].to_i
end
if !params["location_id"].empty?
  @product_instance.location_id = params["location_id"].to_i
end
  @product_instance.save
  erb :edit_success
  # add option back to main menu here.
end




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


