require 'date'

class TimeHelper
  FILENAME = "spec_helper_times.yml"
  def self.record_require_time(require_time)
    datas = all_data
    date_time = serialized_now
    datas[date_time] = require_time
    write_data(datas)
  end

  def self.get_require_time(run_date)
    datas = all_data
    datas[CrappyORM.serialize(run_date)]
  end

  def self.all_data
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

  private

  def self.serialized_now
    CrappyORM.serialize(Clock.now)
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

class Clock
  def self.now
    DateTime.now
  end
end
