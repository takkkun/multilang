require 'yaml'

module Multilang
  module LanguageNames
    NAME_MAP, CODE_MAP = begin
      name_map = {}
      code_map = {}

      store = lambda do |map, key, value|
        key = key.downcase
        raise ArgumentError, "already defined #{key.inspect} => #{map[key].inspect} in map" if map[key]
        map[key] = value
      end

      path = File.join(File.dirname(__FILE__), 'language_names.yaml')

      YAML.load_file(path).each do |name, codes|
        store[name_map, name, name]
        codes.each { |code| store[code_map, code, name] }
      end

      [name_map, code_map]
    end

    # Convert from the language specifier to the language name.
    #
    # @param [String] spec the language name
    # @param [Symbol] spec the language code (ISO639-2 or ISO639-1)
    # @return [String] normalized language name
    def self.[](spec)
      map, key = case spec
                 when String then [NAME_MAP, spec]
                 when Symbol then [CODE_MAP, spec.to_s]
                 else             raise TypeError, "can't convert #{spec.class} into #{String} or #{Symbol}"
                 end

      map[key.downcase] or raise ArgumentError, "#{spec.inspect} language specifier does not defined"
    end

  end
end
