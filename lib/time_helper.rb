class TimeHelper
  FILENAME = "spec_helper_times.yml"
  def self.record_require_time(require_time)
    File.open(FILENAME, 'a+') do |file|
      date_time = Clock.now
      file << "#{date_time}: #{require_time}\n"
    end
  end
end

class Clock
  def self.now
    serialize(DateTime.now)
  end

  def self.serialize(date_time)
    date_time.strftime("%m%d%y%H%M")
  end
end
