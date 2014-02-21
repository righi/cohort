class Order < ActiveRecord::Base
  belongs_to :user

  # Returns true if this is the user's very first order?
  def first_order?
    self.order_num === 1
  end

end
