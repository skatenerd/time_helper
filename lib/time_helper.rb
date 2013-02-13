require 'date'
require 'compute'
require 'run'
require 'crappy_orm'

class TimeHelper

  attr_accessor :clock

  def initialize(clock)
    @clock = clock
  end
  
  def self.record_require_time(require_time)
    new(DateTime).record_require_time(require_time)
  end

  def self.get_require_time(run_date)
    new(DateTime).get_require_time(run_date)
  end

  def self.total_require_time(run_date=nil)
    compute_factory.total_require_time(run_date)
  end

  def self.is_it_worth_it
    hours_required = IOPrompt.prompt_float "How many hours will it take you to fix spec helper?"
    months_more = IOPrompt.prompt_float "How many more months will you be working on the project"

    hours_you_will_save = compute_factory.hours_you_will_save(hours_required, months_more)

    if hours_you_will_save > 0
      puts "Not worth it.  You will not save time in the end by fixing spec helper"
    else
      puts "You should fix it! You will save #{hours_saved}!!!"
    end
  end

  def record_require_time(require_time)
    CrappyORM.new(DateTime).save_run(Run.new(@clock.now, require_time))
  end

  def get_require_time(run_date)
    CrappyORM.new(DateTime).find_run_by_date(run_date).time
  end
  private
  def self.compute_factory
    Compute.new(CrappyORM.new(DateTime), DateTime)
  end

end
