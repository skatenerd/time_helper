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
end
