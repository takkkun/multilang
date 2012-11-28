require 'multilang/language_names'

module Multilang
  class Slot
    def initialize
      @items = {}
    end

    # Register the object to the slot.
    #
    # @param [String, Symbol] language_spec the language specifier
    # @param [Object] object object to register
    # @yield called once at getting the object first
    #
    # @see Multilang::Slot#[]
    def register(language_spec, object, &first)
      item = {:object => object}
      item[:first] = first if first
      @items[LanguageNames[language_spec]] = item
    end

    # Determine if registered with the language specifier in the slot.
    #
    # @param [String, Symbol] language_spec the language specifier
    # @return whether registered with the language specifier in the slot
    def exists?(language_spec)
      !!@items[LanguageNames[language_spec]]
    end

    # Get the object by the language specifier. And call once the block that was
    # given at registration the object.
    #
    # @param [String, Symbol] language_spec the language specifier
    # @return [Object] registered object in the slot
    #
    # @see Multilang::Slot#register
    def [](language_spec)
      language_name = LanguageNames[language_spec]
      raise ArgumentError, "#{language_spec.inspect} does not register" unless @items.key?(language_name)
      item = @items[language_name]

      if item[:first]
        item[:first].call
        item.delete(:first)
      end

      item[:object]
    end

    module Access

      # @attribute [r] slot
      # @return [Multilang::Slot] slot that is bound to class or module
      def slot
        instance_variable_get(Multilang::SLOT_KEY)
      end

      # Get registered object in the slot.
      #
      # @param [String, Symbol] language_spec
      # @return [Object] registered object to the slot
      #
      # @see Multilang::Slot::Access#slot
      # @see Multilang::Slot#[]
      def [](language_spec)
        slot[language_spec]
      end

    end
  end
end
