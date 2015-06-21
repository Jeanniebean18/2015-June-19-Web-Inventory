
require_relative "productclass.rb"
require_relative "locationclass.rb"
require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Location
  extend DatabaseClassMethods
  attr_reader :id
  attr_accessor :name, :address
  # Initializes a new Location object.
  #
  # id (optional)       - Integer of the category record in the 'categories'
  #                         
  # name (optional)     - String of the location's name.
  #
  # address (optional)  - String of the location's address.
  #
  # Returns a Location Hash.
  def initialize(location_options = {})
    @id = location_options["id"]
    @name = location_options["name"]
    @address = location_options["address"]
  end
  # in_location - an Array of valid location IDS.
  # Functions to make a key to check if input is a valid location id. 
  #
  # Returns an array of location ids. 
  def self.in_location
    results_as_objects = []
    Location.all.each do |location|
      results_as_objects << location.id
    end
    return results_as_objects
  end
end