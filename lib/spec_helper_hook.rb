require_relative './time_helper'

unless defined?(REQUIRED_SPEC_HELPER)
  REQUIRED_SPEC_HELPER = true
  start_time = Time.now
  Kernel.load("spec_helper.rb", true)
  TimeHelper.record_require_time(Time.now - start_time)
end
