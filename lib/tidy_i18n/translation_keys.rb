module TidyI18n
  class TranslationKeys
    class InvalidEntry < StandardError; end

    def self.parse(yaml)
      new(yaml).keys
    end

    class RepeatKeyBuilder

      TranslationKey = Struct.new(:name, :value)
      attr_reader :parsed_keys

      def initialize
        self.key_parts = []
        self.parsed_keys = []
      end

      def start_stream(*row); end
      def start_document(*row); end
      def start_sequence(*row)
        raise InvalidEntry.new("\"#{@key_parts.join(".")}\" is not valid")
      end

      def start_mapping(*row)
        @last_scalar = nil
      end

      def scalar(*row)
        if leaf?
          parsed_keys << TranslationKey.new(key_parts.join("."), row.first)
          @last_scalar = nil
          key_parts.pop
        else
          key_parts << row.first
          @last_scalar = row
        end
      end

      def end_mapping(*row)
        @key_parts.pop
      end

      def end_document(*row); end
      def end_stream(*row); end

      private

      def leaf?
        @last_scalar
      end

      attr_accessor :key_parts

      attr_writer :parsed_keys

    end

    def initialize(yaml)
      self.yaml = yaml
    end

    def keys
      @keys ||= build_keys
    end

    private

    def build_keys
      builder = RepeatKeyBuilder.new
      parser = Psych::Parser.new builder
      parser.parse(yaml)
      builder.parsed_keys
    end

    attr_accessor :yaml

  end
end
