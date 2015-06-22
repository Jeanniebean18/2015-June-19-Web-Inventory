get "/category_list" do
  erb :"category_list" 
end
get "/edit_category/:x" do
  @category = Category.find(params["x"])
  erb :"edit_category" # where the edit store form lives for stores.
end

get "/save_category" do
  @category = Category.find(params["id"])
  if params["name"].empty?
    @error = true
    erb :"edit_category"
  else
    @category.name = params["name"]
    @category.save
    erb :"edit_category_success"
  end
end

get "/add_category" do
    erb :"add_category"
end

  get "/save_new_category" do
    if params["name"].empty? 
      # Unsuccessful edit page.
      @error = true
      erb :"add_category"
     else 
      Category.add({"name" => params["name"]})
      # Successful edit page.
      erb :"save_category_success"
    end
end

get "/delete_category_list" do
    #show form with product to pick from and
    # another field checking yes. 
    # submit
    erb :"show_categories_delete"
  end

  get "/delete_category" do
    @category_delete = Category.find(params["id"])
    if params["decision"] == "yes"
      @category_delete.delete
      erb :"category_success_delete"
    else
      erb :"category_not_deleted"
      # erb :"delete_success"
    end
  end
