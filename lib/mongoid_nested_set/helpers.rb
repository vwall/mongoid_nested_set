# encoding: utf-8
module Mongoid::Acts::NestedSet
  module Helpers
    # Returns options for select.
    # You can exclude some items from the tree.
    # You can pass a block receiving an item and returning the string displayed in the select.
    #
    # == Params
    #  * +class_or_item+ - Class name or top level times
    #  * +mover+ - The item that is being move, used to exlude impossible moves
    #  * +&block+ - a block that will be used to display: { |item| ... item.name }
    #
    # == Usage
    #
    #   <%= f.select :parent_id, nested_set_options(Category, @category) {|i|
    #       "#{'–' * i.level} #{i.name}"
    #     }) %>
    #
    def nested_set_options(class_or_item, mover = nil)
      class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
      items = Array(class_or_item)
      result = []
      items.each do |root|
        result += root.self_and_descendants.map do |i|
          if mover.nil? || mover.new_record? || mover.move_possible?(i)
            [yield(i), i.id]
          end
        end.compact
      end
      result
    end
  end
end