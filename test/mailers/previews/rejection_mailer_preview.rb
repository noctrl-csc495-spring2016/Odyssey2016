# Preview all emails at http://localhost:3000/rails/mailers/rejection_mailer
class RejectionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/rejection_mailer/reject_pickup
  def reject_pickup
    RejectionMailer.reject_pickup(Pickup.third)
  end

end
