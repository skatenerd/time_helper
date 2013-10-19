require 'compute'

describe Compute do
  it 'computes months since start for 0' do
    all_runs = [
      Run.new((DateTime.now - 1), 100)
    ]
    database = double(all_runs: all_runs)
    Compute.new(database, Clock).months_since_start.should be_within(0.1).of(0)
  end

  it 'computes months since start for 1' do
    all_runs = [
      Run.new((DateTime.now - 60), 100),
    ]
    database = double(all_runs: all_runs)
    Compute.new(database, Clock).months_since_start.should be_within(0.1).of(2)
  end

  it 'projects time you will save' do
    seconds_in_hour = 60*60
    all_runs = [
      Run.new((DateTime.now - 30), seconds_in_hour),
    ]
    database = double(all_runs: all_runs)
    Compute.new(database, Clock).hours_you_will_save(5, 10).should be_within(0.1).of(5)
  end
end

