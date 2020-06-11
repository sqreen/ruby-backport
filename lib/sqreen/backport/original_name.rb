# typed: ignore

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'sqreen/backport'

module Sqreen::Backport
  module OriginalName
    HAS_UNBOUND_METHOD_ORIGINAL_NAME = ::UnboundMethod.instance_methods(false).include?(:original_name)
    HAS_METHOD_ORIGINAL_NAME = ::Method.instance_methods(false).include?(:original_name)

    def original_name
      self.class.get_original_name(owner, original_name_key) || self.original_name = name
    end

    private

    def original_name=(name)
      self.class.set_original_name(owner, original_name_key, name)
    end

    def original_name_key
      return hash if is_a?(::UnboundMethod)

      owner.instance_method(name).hash
    end

    class << self
      def supported?
        !::Kernel.const_defined?(:JRUBY_VERSION) &&
          HAS_UNBOUND_METHOD_ORIGINAL_NAME &&
          HAS_METHOD_ORIGINAL_NAME
      end

      def included(klass)
        klass.extend(ClassMethods)
      end

      def prepended(klass)
        klass.extend(ClassMethods)
      end
    end

    class Store < ::Hash; end

    module ClassMethods
      def original_names(owner)
        owner.instance_eval { @__sqreen_backport_original_names ||= Store.new }
      end

      def get_original_name(owner, key)
        original_names(owner)[key]
      end

      def set_original_name(owner, key, name)
        original_names(owner)[key] ||= name
      end
    end
  end
end

class UnboundMethod
  if Sqreen::Backport::OriginalName::HAS_UNBOUND_METHOD_ORIGINAL_NAME
    prepend Sqreen::Backport::OriginalName
  else
    include Sqreen::Backport::OriginalName
  end
end unless Sqreen::Backport::OriginalName.supported?

class Method
  if Sqreen::Backport::OriginalName::HAS_METHOD_ORIGINAL_NAME
    prepend Sqreen::Backport::OriginalName
  else
    include Sqreen::Backport::OriginalName
  end
end unless Sqreen::Backport::OriginalName.supported?

class Module
  alias_method(:alias_method_without_original_name, :alias_method)

  def alias_method_with_original_name(newname, oldname)
    alias_method_without_original_name(newname, oldname).tap do
      instance_method(newname).send(:original_name=, :"#{oldname}")
    end
  end

  alias_method_with_original_name(:alias_method_without_original_name, :alias_method)
  alias_method_with_original_name(:alias_method, :alias_method_with_original_name)
end unless Sqreen::Backport::OriginalName.supported?
