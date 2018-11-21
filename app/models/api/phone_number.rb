# frozen_string_literal: true

module Api
  class PhoneNumber < ApplicationRecord
    MIN_NUM = 1_111_111_111
    MAX_NUM = 9_999_999_999

    def self.allot_num(options = {})
      return PhoneNumber.allot_preferred_num if options[:preferred].present?

      PhoneNumber.allot_available_num
    end

    def self.allot_preferred_num(preferred_num)
      preferred_num_exists = PhoneNumber.find_by_phone_num(preferred_num)
      return PhoneNumber.allot_available_num if preferred_num_exists.present?

      PhoneNumber.create(phone_num: preferred_num)
    end

    def self.allot_available_num
      available_num = PhoneNumber.pick_available_num
      PhoneNumber.create(phone_num: available_num,
                         picked_by_sys: true)
    end

    def self.pick_available_num
      last_num_picked_by_sys = PhoneNumber.where(picked_by_sys: true)
                                          .maximum(:phone_num)
      return MIN_NUM if last_num_picked_by_sys.blank?

      new_picked_num = last_num_picked_by_sys.next

      while PhoneNumber.exists?(phone_num: new_picked_num)

        new_picked_num = new_picked_num.next
      end
      new_picked_num
    end
  end
end
