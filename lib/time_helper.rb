require 'date'
require_relative './compute'
require_relative './run'
require_relative './clock'
require_relative './crappy_orm'
require_relative './io_prompt'

class TimeHelper

  attr_accessor :clock

  def initialize(clock)
    @clock = clock
  end

  def self.record_require_time(require_time)
    new(Clock).record_require_time(require_time)
  end

  def self.total_require_time(run_date=nil)
    compute_factory.total_require_time(run_date)
  end

  def self.is_it_worth_it
    hours_required = IOPrompt.prompt_float "How many hours will it take you to fix spec helper?"
    months_more = IOPrompt.prompt_float "How many more months will you be working on the project"

    hours_you_will_save = compute_factory.hours_you_will_save(hours_required, months_more)

    if hours_you_will_save < 0
      puts "Not worth it.  You will not save time in the end by fixing spec helper"
    else
      puts "You should fix it! You will save #{hours_you_will_save} hours!!!"
    end
  end

  def record_require_time(require_time)
    CrappyORM.new(clock).save_run(Run.new(clock.now, require_time))
  end

  private
  def self.compute_factory
    Compute.new(CrappyORM.new(Clock), Clock)
  end

end
