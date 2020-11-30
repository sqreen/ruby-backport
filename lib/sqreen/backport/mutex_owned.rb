# typed: ignore

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'sqreen/backport'

module Sqreen::Backport::MutexOwned
  HAS_MUTEX_OWNED = Mutex.new.respond_to?(:owned?)

  class << self
    def supported?
      Mutex.new.respond_to?(:owned?)
    end
  end

  def owned?
    locked? && synchronize { return false }
  rescue ThreadError
    return true
  end
end

unless Sqreen::Backport::MutexOwned.supported?
  Mutex.instance_eval do
    include Sqreen::Backport::MutexOwned
  end
end
