class User < ActiveRecord::Base
  has_many :orders, -> { order "order_num" }
  # scope :made_a_purchase_during_week, -> (week_since_signup) { where("created_at < ?", time) }

  def self.find_cohort(signup_date, range=1.week)
    start_date = signup_date.beginning_of_day
    end_date = (start_date +range).end_of_day
    users = User.includes(:orders).where(:created_at => start_date..end_date)

    Gaggle.new(:start_date => start_date, :end_date => end_date, :users => users)
  end

  # Answers the question: Did this user place an order during their Xth week since signing up?
  # Indexing starts at 0.
  def placed_order_during_week?(week_num, first_order_only: false)
    begin_date = self.created_at.beginning_of_day + week_num.weeks
    end_date = (begin_date + 6.days).end_of_day
    placed_order_during_timeframe?(begin_date, end_date, first_order_only: first_order_only)
  end

  def placed_order_during_timeframe?(begin_date, end_date, first_order_only: false)
    orders_in_timeframe(begin_date, end_date, first_order_only: first_order_only).present?
  end

  def orders_in_timeframe(begin_date, end_date, first_order_only: false)
    self.orders.select do |order|
      order.created_at.between?(begin_date, end_date) && (!first_order_only || order.first_order?)
    end
  end

end
