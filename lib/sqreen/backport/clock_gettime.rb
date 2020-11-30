# typed: ignore

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

require 'sqreen/backport'

module Sqreen::Backport::ClockGettime
  class << self
    def supported?
      Process.respond_to?(:clock_gettime)
    end
  end

  unless supported?
    require 'ffi'

    class Timespec < FFI::Struct
      layout :tv_sec => :time_t, :tv_nsec => :long
    end

    module LibC
      extend FFI::Library
      ffi_lib FFI::Library::LIBC

      # TODO: FFI::NotFoundError

      if RUBY_PLATFORM =~ /darwin/
        attach_function :mach_absolute_time, [], :uint64
      end

      attach_function :clock_gettime, [:int, :pointer], :int
    end

    module Constants
      case RUBY_PLATFORM
      when /darwin/
        CLOCK_REALTIME = 0
        CLOCK_MONOTONIC = 6
        CLOCK_PROCESS_CPUTIME_ID = 12
        CLOCK_THERAD_CPUTIME_ID = 16
      when /linux/
        CLOCK_REALTIME = 0
        CLOCK_MONOTONIC = 1
        CLOCK_PROCESS_CPUTIME_ID = 2
        CLOCK_THREAD_CPUTIME_ID = 3
      end
    end

    def clock_gettime(clock_id, unit = :float_second)
      unless unit == :float_second
        raise "Process.clock_gettime: unsupported unit #{unit.inspect}"
      end

      t = Sqreen::Backport::ClockGettime::Timespec.new
      ret = Sqreen::Backport::ClockGettime::LibC.clock_gettime(clock_id, t.pointer)

      raise SystemCallError, "Errno #{FFI.errno}" if ret == -1

      t[:tv_sec].to_f + t[:tv_nsec].to_f / 1_000_000_000
    end
  end
end

unless Sqreen::Backport::ClockGettime.supported?
  Process.instance_eval do
    extend Sqreen::Backport::ClockGettime
    include Sqreen::Backport::ClockGettime::Constants
  end
end
