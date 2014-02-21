class Order < ActiveRecord::Base
  belongs_to :user

  # Is this the user's very first order?
  def first_order?
    self.order_num === 1
  end

end
