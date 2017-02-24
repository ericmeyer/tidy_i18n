require "psych"

module TidyI18n
  TranslationKey = Struct.new(:name, :value)
  class TranslationKeys

    def self.parse(yaml)
      new(yaml).keys
    end

    class RepeatKeyBuilder

      attr_reader :parsed_keys

      def initialize
        self.key_parts = []
        self.parsed_keys = []
      end

      def start_stream(*row); end
      def start_document(*row); end
      def start_sequence(*row)
        self.current_sequence_key = TranslationKey.new(key_parts.join("."), [])
      end

      def start_mapping(*row)
        @last_scalar = nil
      end

      def scalar(*row)
        current_sequence_key.value << row.first if building_sequence?
        if leaf?
          append_parsed_key(row)
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
      def end_sequence
        self.current_sequence_key = nil
      end

      private

      def append_parsed_key(row)
        if building_sequence?
          parsed_keys << current_sequence_key
        else
          parsed_keys << TranslationKey.new(key_parts.join("."), row.first)
        end
        key_parts.pop
        @last_scalar = nil
      end

      def building_sequence?
        !current_sequence_key.nil?
      end

      def leaf?
        @last_scalar
      end

      attr_accessor :key_parts, :current_sequence_key
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
      parser = Psych::Parser.new(builder)
      parser.parse(yaml)
      builder.parsed_keys
    end

    attr_accessor :yaml

  end
end
