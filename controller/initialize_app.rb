# frozen_string_literal: true

# class for Controller
class Controller
  def initialize(n = 10)
    return unless Slot.count.zero?

    n.times do
      Slot.create
    end
  end

  def reset_db
    DATABASE[:slots].exclude(car_id: nil).update(car_id: nil, entry_time: nil)
    DATABASE[:invoices].delete
    DATABASE[:cars].delete
  end
end
