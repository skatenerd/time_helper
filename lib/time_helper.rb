class TimeHelper
  def self.record(require_time)
    File.open("spec_helper_times.yml", 'a+') do |file|
      date_time = DateTime.now.strftime("%m%d%y%H%M")
      file << "#{date_time}: #{require_time}\n"
    end
  end
end
