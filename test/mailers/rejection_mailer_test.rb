require 'test_helper'

class RejectionMailerTest < ActionMailer::TestCase
  setup do 
    @pickup = Pickup.first
  end
  
  test "reject_pickup" do
    mail = RejectionMailer.reject_pickup(@pickup)

    assert_equal "Reject Pickup", mail.subject
    assert_equal ["foo@valid.com"], mail.to
    assert_equal ["odyssey.alpha@gmail.com"], mail.from

  end

end
