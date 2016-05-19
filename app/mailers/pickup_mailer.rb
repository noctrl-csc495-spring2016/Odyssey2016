class PickupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pickup_mailer.reject_email.subject
  #
  def reject_email(pickup)
    @greeting = "Hi"
    @pickup = pickup

    mail to: @pickup.donor_email, subject: "Pickup Rejected"
  end
end
