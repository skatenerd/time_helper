require 'run'

class CrappyORM
  attr_accessor :clock
  FILENAME = "spec_helper_times.yml"
  def initialize(clock)
    @clock = clock
  end

  def save_run(run)
    datas = raw_runs
    datas[clock.serialize(run.date)] = run.time
    write_data(datas)
  end

  def all_runs
    raw_runs.map do |k,v|
      Run.new(clock.deserialize(k), v)
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
end

