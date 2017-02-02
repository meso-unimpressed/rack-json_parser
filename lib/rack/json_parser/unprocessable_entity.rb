require 'rack/json_parser/error'

module Rack
  class JSONParser
    # A error signaling that the application should respond with
    # unprocessable entity
    class UnprocessableEntity < Error
      def initialize(detail)
        super('UnprocessableEntity', detail: detail, status_code: 422)
      end
    end
  end
end
