require 'date'

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
    new(DateTime).total_require_time(run_date)
  end

  def total_require_time(run_date=nil)
    run_date ||= DateTime.parse("january 1, 1876")
    entries_after(run_date).reduce(0) do |total, time|
      total += time
      total
    end
  end

  def record_require_time(require_time)
    CrappyORM.save_run(Run.new(@clock.now, require_time))
  end

  def get_require_time(run_date)
    CrappyORM.find_run_by_date(run_date).time
#    datas = self.class.all_data
#    datas[CrappyORM.serialize_datetime(run_date)]
  end

  private

  def entries_after(threshold_date)
    runs = CrappyORM.all_runs.select do |run|
      run.date >= threshold_date     
    end
    runs.map(&:time)
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
  FILENAME = "spec_helper_times.yml"

  def self.save_run(run)
    datas = raw_runs
    datas[serialize_datetime(run.date)] = run.time
    write_data(datas)
  end

  def self.find_run_by_date(date)
    Run.new(date, raw_runs[serialize_datetime(date)])
  end

  def self.all_runs
    raw_runs.map do |k,v|
      Run.new(deserialize_datetime(k), v)
    end
  end

  def self.raw_runs
    file = open(FILENAME, "a+")
    data = YAML.load(file.read)
    file.close
    data ||= {}
    data
  end

  def self.write_data(data)
    f=File.open(FILENAME, 'w+')
    f.write(YAML.dump(data))
    f.close
  end

  def self.deserialize_datetime(serialized)
    DateTime.parse(serialized)
  end

  def self.serialize_datetime(date_time)
    date_time.strftime("%b %d %Y %H:%M:%S")
  end
end
