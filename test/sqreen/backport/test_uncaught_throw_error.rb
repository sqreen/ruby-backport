# typed: false

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'minitest/autorun'
require 'test_helper'

require 'sqreen/backport/uncaught_throw_error'

class Sqreen::Backport::UncaughtThrowErrorTest < Minitest::Test
  def test_has_const
    assert_equal('constant', defined?(::Object::UncaughtThrowError))
  end

  def test_error_thrown
    assert_raises(ArgumentError) { throw }
    assert_raises(UncaughtThrowError) { throw(:foo) }
  end

  def test_error_thrown_has_message
    throw(:foo)
  rescue => e
    assert_equal(UncaughtThrowError, e.class)
    assert_equal('uncaught throw :foo', e.message)
  end

  def test_error_thrown_has_symbol_tag
    throw(:foo)
  rescue => e
    assert_equal(UncaughtThrowError, e.class)
    assert_equal(:foo, e.tag)
  end

  def test_error_thrown_has_string_tag
    throw('foo')
  rescue => e
    assert_equal(UncaughtThrowError, e.class)
    assert_equal('foo', e.tag)
  end

  def test_error_thrown_has_object_tag
    throw(o = Object.new)
  rescue => e
    assert_equal(UncaughtThrowError, e.class)
    assert_equal(o, e.tag)
  end

  def test_error_thrown_has_value
    throw(:foo, 'bar')
  rescue => e
    assert_equal(UncaughtThrowError, e.class)
    assert_equal('bar', e.value)
  end
end
