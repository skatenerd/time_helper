require 'time_helper'
 
unless defined?(REQUIRED_SPEC_HELPER)
  REQUIRED_SPEC_HELPER = true
  start_time = Time.now
  Kernel.load("spec_helper.rb", true)
  TimeHelper.record(Time.now - start_time)
end
