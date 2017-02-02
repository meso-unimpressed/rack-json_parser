# frozen_string_literal: true
require 'rack/json_parser/error'

module Rack
  class JSONParser
    # A error signaling that the application should respond with bad request
    class BadRequest < Error
      def initialize(detail)
        super('Bad request', detail: detail, status_code: 400)
      end
    end
  end
end
