class RejectionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rejection_mailer.reject_pickup.subject
  #
  def reject_pickup
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
