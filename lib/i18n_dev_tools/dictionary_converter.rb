# encoding: UTF-8
require "i18n_dev_tools/translations"

module I18nDevTools
  class DictionaryConverter

    class InvalidTranslationValue < StandardError
    end

    def initialize(dictionary, locale)
      self.dictionary = dictionary
      self.locale = locale
    end

    def converted_dictionary
      convert_dictionary(dictionary, [])
    end

    private

    def convert_dictionary(dictionary, path)
      dictionary.each_with_object({}) do |(key, value), new_dictionary|
        new_dictionary[key] = convert_value(value, path + [key])
      end
    end

    def convert_value(value, path)
      case value.class.name
      when "String"
        locale.convert(value)
      when "Hash"
        convert_dictionary(value, path)
      when "Array"
        value.collect { |v| convert_value(v, path) }
      when "Fixnum", "FalseClass", "TrueClass", "NilClass", "Symbol"
        value
      else
        raise InvalidTranslationValue.new("#{path.join('.')} #{value.class.name} #{value.inspect}")
      end
    end

    attr_accessor :dictionary, :locale

  end
end
