require_relative "productclass.rb"
require_relative "locationclass.rb"
require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Category
  extend DatabaseClassMethods
  attr_reader :id
  attr_accessor :name
  # Initializes a new Category object.
  #
  # id (optional)    - Integer of the category record in the 'categories'
  #                         
  # name (optional)  - String of the category's name.
  #
  # Returns a Category Hash.
  def initialize(category_options={})
    @id = category_options["id"]
    @name = category_options["name"]
  end
  # in_category - an Array of valid category IDS. 
  #
  # Returns an array of category ids. 
  def self.in_category
    results_as_objects = []
    Category.all.each do |category|
      results_as_objects << category.id
    end
    return results_as_objects
  end
  
  def save
    CONNECTION.execute("UPDATE categories SET name = '#{@name}' WHERE id = #{@id};")
  end
  
  
  def delete
    CONNECTION.execute("DELETE FROM categories WHERE id = #{@id};") # need to see if this one will work, if not look up.
  end
end