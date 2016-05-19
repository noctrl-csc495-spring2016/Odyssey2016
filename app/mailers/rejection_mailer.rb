class RejectionMailer < ApplicationMailer

  def reject_pickup(pickup)
    @pickup = pickup

    mail(to: @pickup.donor_email, subject: 'Reject Pickup')
  end
end
