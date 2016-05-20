require 'test_helper'

class RejectionMailerTest < ActionMailer::TestCase
  test "reject_pickup" do
    mail = RejectionMailer.reject_pickup
    assert_equal "Reject pickup", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
