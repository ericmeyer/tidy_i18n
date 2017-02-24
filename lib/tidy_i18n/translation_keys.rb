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
        # move to start_stream? or even start_document?
        # self.key_parts = []
        self.parsed_keys = []
      end

      def start_stream(*row)
        puts "start_stream"
      end
      def start_document(*row)
        # puts "start_document"
      end
      def start_sequence(*row)
        puts "start_sequence"
        # self.current_sequence_key = TranslationKey.new(key_parts.join("."), [])
      end

      def start_mapping(*row)
        puts "start_mapping: #{row.inspect}"
        self.current_scalars = []
        # self.current_key = TranslationKey.new(row.first)
        # @last_scalar = nil

      end

      def scalar(*row)
        puts "scalar: #{row.inspect}"
        self.current_scalars = current_scalars + [row.first]
        # current_sequence_key.value << row.first if building_sequence?
        # if leaf?
        #   append_parsed_key(row)
        # else
        #   key_parts << row.first
        #   @last_scalar = row
        # end
      end

      def end_mapping(*row)
        puts "end_mapping"
        puts "current_scalars: #{current_scalars.inspect}"
        current_scalars.each_slice(2) do |(name, value)|
          puts name + " " + value
          parsed_keys << TranslationKey.new(name, value)
        end
        # if current_scalars.count == 2
        #   parsed_keys << TranslationKey.new(current_scalars.first, current_scalars.last)
        #   current_scalars = []
        # end
        # @key_parts.pop
      end

      def end_document(*row)
        # puts "end_document"
      end
      def end_stream(*row)
        puts "end_stream"
      end
      def end_sequence
        puts "end_sequence"
        # self.current_sequence_key = nil
      end

      private

      # def append_parsed_key(row)
      #   if building_sequence?
      #     parsed_keys << current_sequence_key
      #   else
      #     parsed_keys << TranslationKey.new(key_parts.join("."), row.first)
      #   end
      #   key_parts.pop
      #   @last_scalar = nil
      # end
      #
      # def building_sequence?
      #   !current_sequence_key.nil?
      # end
      #
      # def leaf?
      #   @last_scalar
      # end
      #
      attr_accessor :current_scalars
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
