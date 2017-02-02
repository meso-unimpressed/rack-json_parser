# frozen_string_literal: true
require 'json'
require 'rack'

require 'rack/json_parser/version'
require 'rack/json_parser/bad_request'
require 'rack/json_parser/unprocessable_entity'

module Rack
  # Parses JSON body of requests and handles errors
  class JSONParser
    # An error indicatating that parsing the json body failed
    class ParseError < BadRequest
      def initialize(error)
        super("parsing json failed: #{error.message}")
      end
    end

    # An error raised if body is nil or empty
    class EmptyBodyError < BadRequest
      def initialize
        super('cannot process empty body')
      end
    end

    # An error raised on invalid content types
    class InvalidContentTypeError < BadRequest
      def initialize(content_type)
        super("cannot process content type #{content_type}")
      end
    end

    # An error raised if the top level of the json document is not a hash
    class NotAnObjectError < UnprocessableEntity
      def initialize
        super("document's top level must be an object")
      end
    end

    def initialize(app, content_type: 'application/json')
      @app = app
      @content_type = content_type
    end

    def call(env)
      parse(env) if should_have_body?(env)
      @app.call(env)
    end

    private

    def should_have_body?(env)
      env.key?('CONTENT_LENGTH')
    end

    def parse(env)
      request = Rack::Request.new(env)
      body = request.body.read
      request.body.rewind
      validate_request!(request, body)

      parsed_body = JSON.parse(body)
      raise NotAnObjectError unless parsed_body.is_a?(Hash)

      env['rack.request.form_input'] = request.body
      env['rack.request.form_hash'] = parsed_body
    rescue JSON::ParserError => error
      raise ParseError, error
    end

    def validate_request!(request, body)
      validate_body!(body)
      validate_content_type!(request)
    end

    def validate_body!(body)
      raise EmptyBodyError if body.nil? || body.empty?
    end

    def validate_content_type!(request)
      content_type = request.content_type

      case content_type
      when *@content_type then true
      else raise InvalidContentTypeError, content_type
      end
    end
  end
end
