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
  elsif params["category_id"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_product"
  elsif params["quantity"].empty? 
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
  else
    erb :"product_not_deleted"
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