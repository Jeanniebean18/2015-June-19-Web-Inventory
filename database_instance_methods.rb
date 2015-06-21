require "active_support"
require "active_support/inflector"


# This module will be **extended** in all of my classes. It contains methods
# that will become **class** methods for the class.

module DatabaseInstanceMethods

  # delete - deleted entire row of object in table according to saved ID in instance.
  # 
  # Returns nil because row is deleted. 
  # instance method.
  def delete_row
    # Figure out the table's name from the object we're calling the method on.
    table_name = self.class.to_s.pluralize.underscore
    CONNECTION.execute("DELETE FROM #{table_name} WHERE id = #{@id};") # need to see if this one will work, if not look up.
  end
  
  # Updates/saves a row's information in a table
  #
  # Returns updated Object
  # def save
  #   table = self.class.to_s.pluralize.underscore
  #
  #   instance_variables = self.instance_variables
  #
  #   attribute_hash = {}
  #
  #   instance_variables.each do |variable|
  #     attribute_hash["#{variable.slice(1..-1)}"] = self.send("#{variable.slice(1..-1)}")
  #   end
  #
  #   individual_instance_variables = []
  #
  #   attribute_hash.each do |key, value|
  #     if value.is_a?(String)
  #       individual_instance_variables << "#{key} = '#{value}'"
  #     else
  #       individual_instance_variables << "#{key} = #{value}"
  #     end
  #   end
  #
  #   for_sql = individual_instance_variables.join(', ')
  #
  #   DATABASE.execute("UPDATE #{table} SET #{for_sql} WHERE id = #{self.id}")
  #
  #   return self
  # end
end