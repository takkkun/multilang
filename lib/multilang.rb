require 'multilang/version'
require 'multilang/slot'

module Multilang
  SLOT_KEY = :@__multilang_slot__

  # Support the class or the module to multilingualization.
  #
  # @param [Class, Module] mod the class (or the module) to register
  # @param [Hash] options
  # @option options [String] :as the language name
  # @option options [Symbol] :as the language code (ISO639-2 or ISO639-1)
  # @option options [String] :with the path of the file to dependent
  # @yield call once at getting the class (or the module) first
  #
  # @see Multilang::Slot#[]
  def self.register(mod, options = {}, &first)
    type = mod.class.name.downcase
    raise TypeError, "can't convert #{mod.class} into #{Module}" unless mod.is_a?(Module)
    raise ArgumentError, "anonymous #{type} can't register" if mod.name.nil?

    namespace = mod.name.split('::')
    class_name = namespace.pop
    language_spec = options[:as] || class_name

    if options[:with]
      path = options[:with]

      first = if block_given?
                f = first
                lambda { require path; f.call }
              else
                lambda { require path }
              end
    end

    raise ArgumentError, "can't permit top-level #{type}" if namespace.empty?
    parent = namespace.inject(Object) { |parent, name| parent.const_get(name) }

    slot = if parent.instance_variable_defined?(SLOT_KEY)
             parent.instance_variable_get(SLOT_KEY)
           else
             parent.extend(Slot::Access)
             parent.instance_variable_set(SLOT_KEY, Slot.new)
           end

    slot.register(language_spec, mod, &first)
  end

  def self.included(klass)
    register klass
  end
end
