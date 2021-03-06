module Spree
  module SpreeMailchimpEcommerce
    module ProductDecorator
      def self.prepended(base)
        base.after_create :create_mailchimp_product
        base.after_update :update_mailchimp_product
      end

      def mailchimp_product
        ::SpreeMailchimpEcommerce::Presenters::ProductMailchimpPresenter.new(self).json
      end

      private

      def create_mailchimp_product
        ::SpreeMailchimpEcommerce::CreateProductJob.perform_later(id) if variants.size.positive?
      end

      def update_mailchimp_product
        ::SpreeMailchimpEcommerce::UpdateProductJob.perform_later(id) if variants.size.positive?
      end
    end
  end
end
Spree::Product.prepend(Spree::SpreeMailchimpEcommerce::ProductDecorator)
