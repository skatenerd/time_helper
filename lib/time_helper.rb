require 'date'

class TimeHelper
  attr_accessor :clock
  FILENAME = "spec_helper_times.yml"

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
    datas = self.class.all_data
    date_time = serialized_now
    datas[date_time] = require_time
    write_data(datas)
  end

  def get_require_time(run_date)
    datas = self.class.all_data
    datas[CrappyORM.serialize_datetime(run_date)]
  end

  def self.all_data
    file = open(FILENAME, "a+")
    data = YAML.load(file.read)
    file.close
    data ||= {}
    data
  end

  private

  def entries_after(threshold_date)
    self.class.all_data.select do |date, _|
      CrappyORM.deserialize_datetime(date) >= threshold_date     
    end.values
  end

  def write_data(data)
    f=File.open(FILENAME, 'w+')
    f.write(YAML.dump(data))
    f.close
  end

  def serialized_now
    CrappyORM.serialize_datetime(@clock.now)
  end
end

class CrappyORM
  def self.deserialize_datetime(serialized)
    DateTime.parse(serialized)
  end

  def self.serialize_datetime(date_time)
    date_time.strftime("%b %d %Y %H:%M:%S")
  end
end
