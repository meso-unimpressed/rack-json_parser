module Rack
  class JSONParser
    # Base class for all JSONParser errors
    class Error < RuntimeError
      attr_reader :status_code, :title, :detail

      def initialize(title, detail: nil, status_code: 500)
        @status_code = status_code
        @title = title
        @detail = detail

        super([title, detail].compact.join(' - '))
      end
    end
  end
end
