require 'date'

class IOPrompt
  def self.prompt_float(prompt)
    puts prompt
    float_input = gets.to_f
    if float_input == 0.0
      puts "Please enter a number"
      return prompt_float(prompt)
    end

    return float_input
  end
end

class Compute

  def initialize(database, clock)
    @database = database
    @clock = clock
  end

  def hours_you_will_save(hours_required, months_more)
    total_require_time_in_hours = total_require_time / 3600
    ((total_require_time_in_hours/months_since_start) * months_more) - hours_required
  end
  
  def total_require_time(run_date=nil)
    run_date ||= @clock.parse("january 1, 1876")
    entries_after(run_date).reduce(0) do |total, time|
      total += time
      total
    end
  end

  def months_since_start
    foo = (@clock.now - @database.all_runs.map(&:date).min) / 30
    foo.to_i
  end

  private

  def entries_after(threshold_date)
    runs = @database.all_runs.select do |run|
      run.date >= threshold_date     
    end
    runs.map(&:time)
  end
end

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

class Run
  attr_accessor :date, :time

  def initialize(date, time)
    @date = date
    @time = time
  end
end

class CrappyORM
  attr_accessor :clock
  FILENAME = "spec_helper_times.yml"
  def initialize(clock)
    @clock = clock
  end

  def save_run(run)
    datas = raw_runs
    datas[serialize_datetime(run.date)] = run.time
    write_data(datas)
  end

  def find_run_by_date(date)
    Run.new(date, raw_runs[serialize_datetime(date)])
  end

  def all_runs
    raw_runs.map do |k,v|
      Run.new(deserialize_datetime(k), v)
    end
  end

  def raw_runs
    file = open(FILENAME, "a+")
    data = YAML.load(file.read)
    file.close
    data ||= {}
    data
  end

  def write_data(data)
    f=File.open(FILENAME, 'w+')
    f.write(YAML.dump(data))
    f.close
  end

  def deserialize_datetime(serialized)
    @clock.parse(serialized)
  end

  def serialize_datetime(date_time)
    date_time.strftime("%b %d %Y %H:%M:%S")
  end
end
