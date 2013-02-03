require 'time_helper'
require 'pry'

class MockClock
  attr_accessor :times

  def initialize(times)
    @times=times
  end

  def now
    @times.shift
  end
end

describe TimeHelper do
  before :each do
    if File.exist?(CrappyORM::FILENAME)
      File.delete(CrappyORM::FILENAME)
    end
  end

  it "records the time" do
    TimeHelper.record_require_time(100)
    datas = CrappyORM.raw_runs
    datas[datas.keys.first].should == 100
    datas.keys.first
  end

  it "retrieves a recorded time" do
    date_object = DateTime.parse("may 4 1886 2:22:14pm")

    clock = stub(now: date_object)
    helper = TimeHelper.new(clock)

    helper.record_require_time(100)

    helper.get_require_time(date_object).should == 100
  end

  it "works with the real time" do
    date_object = DateTime.now
    candidate_checks = [date_object, date_object + (1.0/(3600 * 24))]
    TimeHelper.record_require_time(1992)

    winnar = candidate_checks.detect do |attempt|
      TimeHelper.get_require_time(attempt) == 1992
    end

    winnar.should_not be_nil
  end

  it "supports multiple writes" do
    first_date = DateTime.parse("may 4 1886 2:33:11pm")
    second_date = DateTime.parse("april 29 1992 2:33:11pm")
    clock = MockClock.new([
      first_date,
      second_date
    ])
    time_helper = TimeHelper.new(clock)

    time_helper.record_require_time(100)
    time_helper.record_require_time(200)


    TimeHelper.get_require_time(first_date).should == 100
    TimeHelper.get_require_time(second_date).should == 200
  end

  it "gets total time" do
    clock = MockClock.new([
      DateTime.parse("may 4 1886 2:33:11pm"),
      DateTime.parse("may 4 1886 2:33:12pm"),
      DateTime.parse("may 4 1886 2:33:13pm"),
      DateTime.parse("may 4 1886 2:33:14pm")
    ])
    helper = TimeHelper.new(clock)
    helper.record_require_time(1)
    helper.record_require_time(2)
    helper.record_require_time(3)
    helper.record_require_time(4)

    helper.total_require_time.should == 10
  end

  it "gets total time on or after a certain date" do
    threshold_date = DateTime.parse("may 4 1886 2:33:12pm")

    clock = MockClock.new([
      DateTime.parse("may 4 1886 2:33:11pm"),
      threshold_date,
      DateTime.parse("may 4 1886 2:33:13pm"),
      DateTime.parse("may 4 1886 2:33:14pm")
    ])
    helper = TimeHelper.new(clock)
    helper.record_require_time(1)
    helper.record_require_time(2)
    helper.record_require_time(3)
    helper.record_require_time(4)

    helper.total_require_time(threshold_date).should == 9
  end
end
