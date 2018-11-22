# frozen_string_literal: true

module Api
  class PhoneNumber < ApplicationRecord
    include ActionView::Helpers::NumberHelper

    MIN_NUM = 1_111_111_111
    MAX_NUM = 9_999_999_999
    before_create :setup_phone_text

    def self.allot_number(options = {})
      if options[:preferred].present?
        return PhoneNumber.allot_preferred_num options[:preferred]
      end

      PhoneNumber.allot_available_num
    end

    def self.allot_preferred_num(preferred_num)
      preferred_num.delete!('-')
      if PhoneNumber.valid_preferred_num?(preferred_num)
        return PhoneNumber.create(phone_number: preferred_num)
      end

      PhoneNumber.allot_available_num
    end

    def self.allot_available_num
      available_num = PhoneNumber.pick_available_num
      PhoneNumber.create(phone_number: available_num,
                         picked_by_sys: true)
    end

    def self.pick_available_num
      last_num_picked_by_sys = PhoneNumber.where(picked_by_sys: true)
                                          .maximum(:phone_number)
      return MIN_NUM if last_num_picked_by_sys.blank?

      new_picked_num = last_num_picked_by_sys.next

      while PhoneNumber.exists?(phone_number: new_picked_num)

        new_picked_num = new_picked_num.next
      end
      new_picked_num
    end

    def self.valid_preferred_num?(preferred_num)
      preferred_num_exists = PhoneNumber.find_by_phone_number(preferred_num)

      !preferred_num_exists.present? &&
        preferred_num.to_s.length == MIN_NUM.to_s.length
    end

    ##############
    private

    ##############

    def setup_phone_text
      self.phone_text = number_to_phone phone_number
    end
  end
end
