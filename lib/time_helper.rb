require 'date'

class TimeHelper
  FILENAME = "spec_helper_times.yml"
  def self.record_require_time(require_time)
    File.open(FILENAME, 'a+') do |file|
      date_time = Clock.now
      file << "#{date_time}: #{require_time}\n"
    end
  end

  def self.get_require_time(run_date)
    datas = YAML.load(open(FILENAME))
    datas[Clock.serialize(run_date)]
  end
end

class Clock
  def self.now
    serialize(DateTime.now)
  end

  def self.serialize(date_time)
    date_time.strftime("%m%d%y%H%M%S")
  end
end
