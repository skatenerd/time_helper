require 'run'

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

