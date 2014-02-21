require 'hashie/dash'

# I originally named this Cohort, because that's what it is, but
# the Cohort module is colliding with my desire to have a class by the
# same name. So Gaggle it is.
class Gaggle < Hashie::Dash
  property :users
  property :start_date
  property :end_date
  property :buckets

  def init_buckets(last_bucket_date)
    self.buckets = []

    num_total_users = self.users.length
    _start_date = self.start_date
    week_num = 0
    while _start_date <= last_bucket_date
      num_active_users = users_active_during_week(week_num).length
      num_first_time_users = first_time_purchasers_during_week(week_num).length

      self.buckets << Hashie::Mash.new(
          :pct_active_users       => (num_active_users.fdiv(num_total_users)) * 100,
          :num_active_users       => num_active_users,
          :pct_first_time_users   => (num_first_time_users.fdiv(num_total_users)) * 100,
          :num_first_time_users   => num_first_time_users
      )

      week_num += 1
      _start_date += 1.week
    end
  end

  private

    # Retrieves the users in this cohort who made a purchase during
    # their Xth week of membership. Indexing starts at 0.
    def users_active_during_week(week_num)
      self.users.select{|u| u.placed_order_during_week?(week_num)}
    end

    def first_time_purchasers_during_week(week_num)
      self.users.select{|u| u.placed_order_during_week?(week_num, first_order_only: true)}
    end

end
