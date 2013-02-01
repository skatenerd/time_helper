require 'time_helper'

describe TimeHelper do
  before :each do
    if File.exist?(TimeHelper::FILENAME)
      File.delete(TimeHelper::FILENAME)
    end
  end

  it "records the time according to clock output" do
    TimeHelper.record_require_time(100)
    datas = YAML.load(open(TimeHelper::FILENAME))
    datas[datas.keys.first].should == 100
  end

  it "retrieves a recorded time" do
    serialized_date = "may 4 1886"
    date_object = Date.parse(serialized_date)


    Clock.stub(now: serialized_date)
    Clock.stub(:serialize).with(date_object).and_return(serialized_date)

    TimeHelper.record_require_time(100)

    TimeHelper.get_require_time(date_object).should == 100
  end
end
