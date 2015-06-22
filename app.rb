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

require_relative "controllers/products.rb"
require_relative "controllers/stores.rb"
require_relative "controllers/categories.rb"


#____________________

# Returns a param id for location chosen
# Creates location instance by param ID recieved from products_location.
# Returns a list of products in that location.



# TODO how to make the edit form dynamic?
# TODO add in delete functionality of store.


# use instance . names to show pre-loaded fields. 
