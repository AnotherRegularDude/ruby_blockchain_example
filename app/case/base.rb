# frozen_string_literal: true

class Case::Base < Resol::Service
  use_initializer! :dry
  plugin :return_in_service
end
