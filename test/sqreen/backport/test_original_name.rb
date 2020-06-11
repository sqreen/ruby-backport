# typed: false

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'minitest/autorun'
require 'test_helper'

require 'sqreen/backport/original_name'

class Sqreen::Backport::OriginalNameTest < Minitest::Test
  def mock_klass
    Class.new do
      def foo; end
      alias_method :bar, :foo
      alias_method :baz, :bar

      protected

      def protected_foo; end
      alias_method :protected_bar, :protected_foo

      private

      def private_foo; end
      alias_method :private_bar, :private_foo

      class << self
        def kfoo; end
        alias_method :kbar, :kfoo
        alias_method :kbaz, :kbar

        protected

        def protected_kfoo; end
        alias_method :protected_kbar, :protected_kfoo

        private

        def private_kfoo; end
        alias_method :private_kbar, :private_kfoo
      end
    end
  end

  def test_ruby_method_hash_behaviour
    instance = mock_klass.new
    assert_equal(instance.method(:foo).hash, instance.method(:foo).hash)
    assert_equal(instance.method(:foo).hash, instance.method(:bar).hash)
    refute_equal(instance.method(:foo).hash, instance.method(:to_s).hash)

    klass = mock_klass
    assert_equal(klass.instance_method(:foo).hash, klass.instance_method(:foo).hash)
    assert_equal(klass.instance_method(:foo).hash, klass.instance_method(:bar).hash)
    refute_equal(klass.instance_method(:foo).hash, klass.instance_method(:to_s).hash)

    assert_equal(Kernel.method(:object_id).hash, Kernel.method(:object_id).hash)
    assert_equal(Kernel.instance_method(:object_id).hash, Kernel.instance_method(:object_id).hash)
    refute_equal(Kernel.instance_method(:object_id).hash, Kernel.method(:object_id).hash)
  end

  def test_original_name_on_unbound_method
    klass = mock_klass
    assert_equal(:foo, klass.instance_method(:foo).original_name)
    assert_equal(:foo, klass.instance_method(:bar).original_name)
    assert_equal(:foo, klass.instance_method(:baz).original_name)
    assert_equal(:protected_foo, klass.instance_method(:protected_foo).original_name)
    assert_equal(:protected_foo, klass.instance_method(:protected_bar).original_name)
    assert_equal(:private_foo, klass.instance_method(:private_foo).original_name)
    assert_equal(:private_foo, klass.instance_method(:private_bar).original_name)
  end

  def test_original_name_on_bound_method
    instance = mock_klass.new
    assert_equal(:foo, instance.method(:foo).original_name)
    assert_equal(:foo, instance.method(:bar).original_name)
    assert_equal(:foo, instance.method(:baz).original_name)
    assert_equal(:protected_foo, instance.method(:protected_foo).original_name)
    assert_equal(:protected_foo, instance.method(:protected_bar).original_name)
    assert_equal(:private_foo, instance.method(:private_foo).original_name)
    assert_equal(:private_foo, instance.method(:private_bar).original_name)
  end

  def test_unbound_bound_consistency
    instance = mock_klass.new
    assert_equal(:foo, instance.singleton_class.instance_method(:baz).original_name)
    assert_equal(:foo, instance.singleton_class.instance_method(:bar).original_name)
    assert_equal(:foo, instance.singleton_class.instance_method(:foo).original_name)
    assert_equal(:foo, instance.method(:baz).original_name)
    assert_equal(:foo, instance.method(:bar).original_name)
    assert_equal(:foo, instance.method(:foo).original_name)
  end

  def test_original_name_on_singleton_bound_method
    instance = mock_klass.new
    instance.singleton_class.class_eval do
      def sfoo; end
      alias_method :sbar, :sfoo
      alias_method :sbaz, :sbar

      protected

      def protected_sfoo; end
      alias_method :protected_sbar, :protected_sfoo

      private

      def private_sfoo; end
      alias_method :private_sbar, :private_sfoo
    end
    assert_equal(:sfoo, instance.method(:sfoo).original_name)
    assert_equal(:sfoo, instance.method(:sbar).original_name)
    assert_equal(:sfoo, instance.method(:sbaz).original_name)
    assert_equal(:protected_sfoo, instance.method(:protected_sfoo).original_name)
    assert_equal(:protected_sfoo, instance.method(:protected_sbar).original_name)
    assert_equal(:private_sfoo, instance.method(:private_sfoo).original_name)
    assert_equal(:private_sfoo, instance.method(:private_sbar).original_name)
  end

  def test_original_name_on_singleton_unbound_method
    instance = mock_klass.new
    instance.singleton_class.class_eval do
      def sfoo; end
      alias_method :sbar, :sfoo
      alias_method :sbaz, :sbar

      protected

      def protected_sfoo; end
      alias_method :protected_sbar, :protected_sfoo

      private

      def private_sfoo; end
      alias_method :private_sbar, :private_sfoo
    end
    assert_equal(:sfoo, instance.singleton_class.instance_method(:sfoo).original_name)
    assert_equal(:sfoo, instance.singleton_class.instance_method(:sbar).original_name)
    assert_equal(:sfoo, instance.singleton_class.instance_method(:sbaz).original_name)
    assert_equal(:protected_sfoo, instance.singleton_class.instance_method(:protected_sfoo).original_name)
    assert_equal(:protected_sfoo, instance.singleton_class.instance_method(:protected_sbar).original_name)
    assert_equal(:private_sfoo, instance.singleton_class.instance_method(:private_sfoo).original_name)
    assert_equal(:private_sfoo, instance.singleton_class.instance_method(:private_sbar).original_name)
  end

  def test_original_name_on_klass_unbound_method
    klass = mock_klass
    assert_equal(:kfoo, klass.singleton_class.instance_method(:kfoo).original_name)
    assert_equal(:kfoo, klass.singleton_class.instance_method(:kbar).original_name)
    assert_equal(:kfoo, klass.singleton_class.instance_method(:kbaz).original_name)
    assert_equal(:protected_kfoo, klass.singleton_class.instance_method(:protected_kfoo).original_name)
    assert_equal(:protected_kfoo, klass.singleton_class.instance_method(:protected_kbar).original_name)
    assert_equal(:private_kfoo, klass.singleton_class.instance_method(:private_kfoo).original_name)
    assert_equal(:private_kfoo, klass.singleton_class.instance_method(:private_kbar).original_name)
  end

  def test_original_name_on_klass_bound_method
    klass = mock_klass
    assert_equal(:kfoo, klass.method(:kfoo).original_name)
    assert_equal(:kfoo, klass.method(:kbar).original_name)
    assert_equal(:kfoo, klass.method(:kbaz).original_name)
    assert_equal(:protected_kfoo, klass.method(:protected_kfoo).original_name)
    assert_equal(:protected_kfoo, klass.method(:protected_kbar).original_name)
    assert_equal(:private_kfoo, klass.method(:private_kfoo).original_name)
    assert_equal(:private_kfoo, klass.method(:private_kbar).original_name)
  end

  def test_backport_included
    skip unless RUBY_VERSION < '2.1' || ::Kernel.const_defined?(:JRUBY_VERSION)

    klass = mock_klass
    assert_instance_of(::UnboundMethod, klass.instance_method(:foo))
    assert_kind_of(Sqreen::Backport::OriginalName, klass.instance_method(:foo))

    instance = klass.new
    assert_instance_of(::Method, instance.method(:foo))
    assert_kind_of(Sqreen::Backport::OriginalName, klass.instance_method(:foo))
  end

  def test_backport_excluded
    skip if RUBY_VERSION < '2.1' || ::Kernel.const_defined?(:JRUBY_VERSION)

    klass = mock_klass
    assert_instance_of(::UnboundMethod, klass.instance_method(:foo))
    refute_kind_of(Sqreen::Backport::OriginalName, klass.instance_method(:foo))

    instance = klass.new
    assert_instance_of(::Method, instance.method(:foo))
    refute_kind_of(Sqreen::Backport::OriginalName, klass.instance_method(:foo))
  end
end
