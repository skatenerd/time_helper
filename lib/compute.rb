class Compute

  def initialize(database, clock)
    @database = database
    @clock = clock
  end

  def hours_you_will_save(hours_required, months_more)
    total_require_time_in_hours = total_require_time / 3600
    ((total_require_time_in_hours/months_since_start) * months_more) - hours_required
  end
  
  def total_require_time(run_date=nil)
    run_date ||= @clock.deserialize("january 1, 1876")
    entries_after(run_date).reduce(0) do |total, time|
      total += time
      total
    end
  end

  def months_since_start
    foo = (@clock.now - @database.all_runs.map(&:date).min) / 30
    foo.to_i
  end

  private

  def entries_after(threshold_date)
    runs = @database.all_runs.select do |run|
      run.date >= threshold_date     
    end
    runs.map(&:time)
  end
end

