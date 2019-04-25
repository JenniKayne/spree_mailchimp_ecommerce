module SpreeMailchimpEcommerce
  class UpdateProductJob < ApplicationJob
    def perform(product_id)
      product = Spree::Product.find_by(id: product_id)
      return unless product

      mailchimp_product = product.mailchimp_product
      return unless mailchimp_product

      begin
        gibbon_store.products(mailchimp_product["id"]).update(body: mailchimp_product)
      rescue Gibbon::MailChimpError => e
        if e.status_code == 404
          gibbon_store.products.create(body: mailchimp_product)
        else
          raise
        end
      end
    end
  end
end
