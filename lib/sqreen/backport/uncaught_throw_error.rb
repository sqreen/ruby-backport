# typed: ignore

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'sqreen/backport'

module Sqreen::Backport::UncaughtThrowError
  HAS_UNCAUGHT_THROW_ERROR = defined?(::Object::UncaughtThrowError)

  class << self
    def supported?
      defined?(::Object::UncaughtThrowError)
    end
  end

  def throw(tag, value = nil)
    super
  rescue ArgumentError => e
    if e.message =~ /^uncaught throw (?:.*)$/
      raise ::Object::UncaughtThrowError.new(tag, value, e.message).tap { |x| x.set_backtrace(e.backtrace) }
    else
      raise
    end
  end
end

unless Sqreen::Backport::UncaughtThrowError.supported?
  ::Object.instance_eval do
    class UncaughtThrowError < ArgumentError
      def initialize(tag, value, *args)
        @tag = tag
        @value = value
        super(*args)
      end

      attr_reader :tag
      attr_reader :value
    end
  end

  ::Kernel.singleton_class.instance_eval { prepend Sqreen::Backport::UncaughtThrowError }
  ::Object.instance_eval { prepend Sqreen::Backport::UncaughtThrowError }
end
