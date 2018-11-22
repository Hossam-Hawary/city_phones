# frozen_string_literal: true

module Api
  class PhoneNumbersController < ApplicationController
    def create
      alloted_number = Api::PhoneNumber.allot_number phone_number_params
      render json: { alloted_number: alloted_number.phone_text }
    end
    ############

    private

    ############

    def phone_number_params
      params.permit(:preferred)
    end
  end
end
