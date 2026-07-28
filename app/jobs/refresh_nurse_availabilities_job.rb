class RefreshNurseAvailabilitiesJob < ApplicationJob
  queue_as :default

  MIN_FUTURE_SLOTS = 5
  DAYS_AHEAD = 5
  HOURS = [8, 9, 10, 11, 14, 15, 16, 17].freeze
  SLOTS_PER_DAY = 2

  def perform
    Nurse.find_each { |nurse| top_up(nurse) }
  end

  private

  def top_up(nurse)
    return if future_unbooked_count(nurse) >= MIN_FUTURE_SLOTS

    (1..DAYS_AHEAD).each { |offset| create_day_slots(nurse, Date.current + offset.days) }
  end

  def future_unbooked_count(nurse)
    nurse.availabilities.where(is_booked: [false, nil]).where("start_time > ?", Time.current).count
  end

  def create_day_slots(nurse, day)
    HOURS.sample(SLOTS_PER_DAY).each do |hour|
      start_time = day.beginning_of_day + hour.hours
      Availability.find_or_create_by!(nurse: nurse, start_time: start_time) do |availability|
        availability.end_time = start_time + 1.hour
        availability.is_booked = false
      end
    end
  end
end
