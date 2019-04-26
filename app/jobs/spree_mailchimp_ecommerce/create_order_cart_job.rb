# frozen_string_literal: true
module SpreeMailchimpEcommerce
  class CreateOrderCartJob < ApplicationJob
    def perform(order_id)
      order = Spree::Order.find_by(id: order_id)

      mailchimp_cart = order&.mailchimp_cart
      return unless mailchimp_cart

      gibbon_store.carts.create(body: mailchimp_cart)
    rescue Gibbon::MailChimpError => e
      raise unless e.status_code == 400
    end
  end
end
