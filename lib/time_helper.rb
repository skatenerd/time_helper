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

  def record_require_time(require_time)
    datas = self.class.all_data
    date_time = serialized_now
    datas[date_time] = require_time
    write_data(datas)
  end

  def get_require_time(run_date)
    datas = self.class.all_data
    datas[CrappyORM.serialize(run_date)]
  end

  def self.all_data
    file = open(FILENAME, "a+")
    data = YAML.load(file.read)
    file.close
    data ||= {}
    data
  end

  private

  def write_data(data)
    f=File.open(FILENAME, 'w+')
    f.write(YAML.dump(data))
    f.close
  end

  def serialized_now
    CrappyORM.serialize(@clock.now)
  end
end

class CrappyORM
  def self.deserialize(serialized)
    DateTime.parse(serialized)
  end

  def self.serialize(date_time)
    date_time.strftime("%b %d %Y %H:%M:%S")
  end
end
