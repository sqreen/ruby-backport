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
    Module.respond_to?(:prepend, true) ? super : throw_without_uncaught_throw_error(tag, value)
  rescue ArgumentError => e
    raise unless e.message =~ /^uncaught throw (?:.*)$/

    x = ::Object::UncaughtThrowError.new(tag, value, e.message)
    x.set_backtrace(e.backtrace)
    raise x
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

  if Module.respond_to?(:prepend, true)
    ::Kernel.singleton_class.instance_eval { prepend Sqreen::Backport::UncaughtThrowError }
    ::Object.instance_eval { prepend Sqreen::Backport::UncaughtThrowError }
  else
    ::Kernel.singleton_class.instance_eval do
      alias_method :throw_without_uncaught_throw_error, :throw
      include Sqreen::Backport::UncaughtThrowError
    end
    ::Object.instance_eval do
      alias_method :throw_without_uncaught_throw_error, :throw
      include Sqreen::Backport::UncaughtThrowError
    end
  end
end
