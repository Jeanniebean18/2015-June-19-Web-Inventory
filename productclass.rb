require_relative "locationclass.rb"
require_relative "categoryclass.rb"
require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Product
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  attr_reader :id
  attr_accessor :name, :brand, :category_id, :quantity, :location_id
 
  # Initializes a new Product object.
  #
  # id (optional) - Integer of the product record in the 'products'
  #                         table.
  # name (optional)         - String of the products's name.
  # brand (optional)        - String of the products's brand.
  # category_id (optional)  - Integer of the products's category_id.
  # quantity (optional)     - Integer of quantity.
  # location_id (optional)  - Integer of product's location_id.
  #
  # Returns a Product Hash.
  
  def initialize(product_options={})
    @id = product_options["id"]
    @name = product_options["name"]
    @brand = product_options["brand"]
    @category_id = product_options["category_id"]
    @quantity = product_options["quantity"]
    @location_id = product_options["location_id"]
  end
  # save - saves entire row in table on the object the method was used on. 
  # Returns hash of updated location row. 
  
  def save
      CONNECTION.execute("UPDATE products SET name = '#{@name}', brand = '#{@brand}', category_id = #{@category_id}, quantity = #{@quantity}, location_id = #{@location_id} WHERE id = #{@id};")
    end
end

  
