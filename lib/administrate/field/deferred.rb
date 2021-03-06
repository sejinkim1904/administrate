require "active_support/core_ext/module/delegation"

module Administrate
  module Field
    class Deferred
      def initialize(deferred_class, options = {})
        @deferred_class = deferred_class
        @options = options
      end

      attr_reader :deferred_class, :options

      def new(*args)
        new_options = args.last.respond_to?(:merge) ? args.pop : {}
        deferred_class.new(*args, options.merge(new_options))
      end

      def ==(other)
        other.respond_to?(:deferred_class) &&
          deferred_class == other.deferred_class &&
          options == other.options
      end

      def associative?
        deferred_class.associative?
      end

      def searchable?
        options.fetch(:searchable, deferred_class.searchable?)
      end

      def searchable_field
        ActiveSupport::Deprecation.warn(
          "searchable_field is deprecated, use searchable_fields instead",
        )
        options.fetch(:searchable_field)
      end

      def searchable_fields
        if options.key?(:searchable_field)
          [searchable_field]
        else
          options.fetch(:searchable_fields)
        end
      end

      def permitted_attribute(attr, _options = nil)
        options.fetch(:foreign_key,
          deferred_class.permitted_attribute(attr, options))
      end

      delegate :html_class, to: :deferred_class
    end
  end
end
