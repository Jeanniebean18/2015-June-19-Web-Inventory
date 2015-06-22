get "/store_list" do
  erb :"store_list" 
end
get "/edit_store/:x" do
  @location = Location.find(params["x"])
  erb :"edit_store" # where the edit store form lives for stores.
end

get "/save_store" do
  @location = Location.find(params["id"])
  if params["name"].empty?
    @error = true
    erb :"edit_store"
  elsif params["address"].empty?
    @error = true
    erb :"edit_store"
  else
    @location.name = params["name"]
    @location.address = params["address"]
    @location.save
    erb :"edit_store_success"
  end
end
get "/add_store" do
  erb :"add_store"
end

get "/save_new_store" do
  if params["name"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_store"
  elsif params["address"].empty? 
    # Unsuccessful edit page.
    @error = true
    erb :"add_store"
   else 
    Location.add({"name" => params["name"], "address" => params["address"]})
    # Successful edit page.
    erb :"save_store_success"
  end
end
  