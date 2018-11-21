# frozen_string_literal: true

module Api
  class PhoneNumber < ApplicationRecord

    def self.allot_number(options = {})
      return PhoneNumber.allot_prefered_number if options[:prefered].present?

      return PhoneNumber.allot_available_number

    end

    def self.allot_prefered_number(prefered_number)
      prefered_number_exists = PhoneNumber.find_by_phone_number(prefered_number)
      return PhoneNumber.allot_available_number if prefered_number_exists.present?

      PhoneNumber.create(prefered_number: prefered_number)
    end

    def self.allot_available_number

    end
  end
end
