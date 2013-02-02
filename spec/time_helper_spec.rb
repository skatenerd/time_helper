require 'time_helper'
require 'pry'

describe TimeHelper do
  before :each do
    if File.exist?(TimeHelper::FILENAME)
      File.delete(TimeHelper::FILENAME)
    end
  end

  it "records the time" do
    TimeHelper.record_require_time(100)
    datas = YAML.load(open(TimeHelper::FILENAME))
    datas[datas.keys.first].should == 100
  end

  it "retrieves a recorded time" do
    serialized_date = "may 4 1886"
    date_object = DateTime.parse(serialized_date)

    Clock.stub(now: serialized_date)
    Clock.stub(:serialize).with(date_object).and_return(serialized_date)

    TimeHelper.record_require_time(100)

    TimeHelper.get_require_time(date_object).should == 100
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
    first_serialized_date = "may 4 1886"
    Clock.stub(:serialize).and_return(first_serialized_date)
    TimeHelper.record_require_time(100)

    second_serialized_date = "april 29 1992"
    Clock.stub(:serialize).and_return(second_serialized_date)
    TimeHelper.record_require_time(200)

    TimeHelper.get_require_time(DateTime.parse(first_serialized_date)).should == 100
    TimeHelper.get_require_time(DateTime.parse(second_serialized_date)).should == 200

  end
end
