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
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  elsif params["brand"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  elsif params["quantity"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  elsif params["category_id"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  elsif params["location_id"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  else 
    Product.add({"name" => params["name"], "brand" => params["brand"], "category_id" => params["category_id"].to_i, "quantity" => params["quantity"].to_i, "location_id" => params["location_id"].to_i})
    # Successful edit page.
    erb :"product_added"
  end
end
# edit_products path displays an edit form for product.
# click on products to edit first. then display pre-loaded form to user. 
# Don't think you would need the empty's anymore. It would just be loaded with the original
# information. 
get "/edit_products" do
  erb :"products_to_edit" 
end

get "/edit_products_form/:x" do
  @product_instance = Product.find(params["x"])
  erb :"products" 
end
# Recieves params from edit_products/products page.
# If fields aren't empty, save new value in object.
# TODO Show full product in edit form. 
get "/edit_save" do
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
  
  #
  # if !params["name"].empty?
  #   @product_instance.name = params["name"]
  # end
  # if !params["brand"].empty?
  #   @product_instance.brand = params["brand"]
  # end
  # if !params["category_id"].empty?
  #   @product_instance.category_id = params["category_id"].to_i
  # end
  # if !params["quantity"].empty?
  #   @product_instance.quantity = params["quantity"].to_i
  # end
  # if !params["location_id"].empty?
  #   @product_instance.location_id = params["location_id"].to_i
  # end
  # Save product in database
  @product_instance.save
  # Success page for editing product
  erb :edit_success
  
end

get "/delete" do
  #show form with product to pick from and
  # another field checking yes. 
  # submit
  erb :"show_products_delete"
end

get "/delete_product" do
  @product_delete = Product.find(params["id"])
  if params["decision"] == "yes"
    @product_delete.delete
    erb :"product_success_delete"
    # erb :"delete_success"
  end
end

# Returns a list of all products.
get "/see_products" do
  erb :"see_products" 
end
# Returns a list of all categories.
# User clicks category to see all products under that category.
get "/products_category" do
  erb :"product_category"
end
# Returns a list of all locations.
# User clicks location to see all products under that location.
get "/products_location" do
  erb :"product_location"
end
get "/store_list" do
  erb :"store_list" 
end
get "/edit_store/:x" do
  @location = Location.find(params["x"])
  erb :"edit_store" # where the edit store form lives for stores.
end

get "/save_store" do
  @location = Location.find(params["id"])
  if !params["name"].empty?
    @location.name = params["name"]
  end
  if !params["address"].empty?
    @location.address = params["address"]
  end
  @location.save
  erb :"edit_store_success"
end




# Returns a param id for location chosen
# Creates location instance by param ID recieved from products_location.
# Returns a list of products in that location.
get "/see_location/:x" do
  @location_instance = Location.find(params["x"])
  @products_in_location = Product.where("location_id", params["x"])
  erb :"see_products_in_location"
end
# Returns a param id for category chosen.
# Creates category instance by param ID recieved from products_category.
# Returns a list of products in that category.
get "/see_category/:x" do
  @category_instance = Category.find(params["x"])
  @products_in_category = Product.where("category_id", params["x"])
  erb :"see_products_in_category"
end


# TODO how to make the edit form dynamic?
# TODO add in delete functionality of store.
# TODO add category function

# use instance . names to show pre-loaded fields. 
