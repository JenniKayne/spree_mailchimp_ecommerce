module SpreeMailchimpEcommerce
  class UpdateUserJob < ApplicationJob
    def perform(user_id)
      user = Spree::User.find_by(id: user_id)

      mailchimp_user = user&.mailchimp_user
      return unless mailchimp_user

      begin
        gibbon_store.customers(mailchimp_user["id"]).update(body: mailchimp_user)
      rescue Gibbon::MailChimpError => e
        if e.status_code == 404
          ::SpreeMailchimpEcommerce::CreateUserJob.perform_later(user_id)
        else
          raise
        end
      end
    end
  end
end
