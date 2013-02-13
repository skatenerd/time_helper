class Clock
  def self.serialize(serialized)
    DateTime.now.strftime("%b %d %Y %H:%M:%S")
  end
  def self.deserialize(serialized)
    DateTime.parse(serialized)
  end
  def self.now
    DateTime.now
  end
end
