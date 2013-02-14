class Clock
  def self.serialize(to_serialize)
    to_serialize.strftime("%b %d %Y %H:%M:%S")
  end
  def self.deserialize(serialized)
    DateTime.parse(serialized)
  end
  def self.now
    DateTime.now
  end
end
