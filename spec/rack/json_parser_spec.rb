# frozen_string_literal: true

require 'spec_helper'
require 'rack/json_parser'

describe Rack::JSONParser do
  subject(:middleware) { described_class.new(app) }
  let(:app) { ->(*) { [200, nil, 'test'] } }

  describe '#call' do
    let(:env) do
      {
        'rack.input' => body,
        'CONTENT_TYPE' => 'application/json',
        'CONTENT_LENGTH' => body_string.to_s.size
      }
    end

    let(:body) { instance_double(IO, read: body_string, rewind: nil) }
    let(:body_string) { '{"test":"foobar"}' }

    it 'responds with the apps result without error' do
      expect(middleware.call(env)).to eq([200, nil, 'test'])
    end

    it 'sets rack.request.form_hash with the parsed json object' do
      middleware.call(env)
      expect(env['rack.request.form_hash']).to eq('test' => 'foobar')
    end

    it 'sets rack.request.form_input with the body' do
      middleware.call(env)
      expect(env['rack.request.form_input']).to be(body)
    end

    context 'with malformed json' do
      let(:body_string) { '{' }

      it 'raises a ParseError' do
        expect { middleware.call(env) }.to raise_error(
          Rack::JSONParser::ParseError
        )
      end
    end

    context 'with no body' do
      let(:body_string) { nil }

      it 'raises an EmptyBodyError' do
        expect { middleware.call(env) }.to raise_error(
          Rack::JSONParser::EmptyBodyError
        )
      end
    end

    context 'with empty body' do
      let(:body_string) { '' }

      it 'raises a EmptyBodyError' do
        expect { middleware.call(env) }.to raise_error(
          Rack::JSONParser::EmptyBodyError
        )
      end
    end

    context 'with no json object at top level' do
      let(:body_string) { '[]' }

      it 'raises a NotAnObjectError' do
        expect { middleware.call(env) }.to raise_error(
          Rack::JSONParser::NotAnObjectError
        )
      end
    end

    context 'with single custom content type' do
      subject(:middleware) do
        described_class.new(app, content_type: custom_content_type)
      end

      let(:custom_content_type) { 'application/vnd.api+json' }

      it 'raises no errors' do
        middleware.call(env.merge('CONTENT_TYPE' => custom_content_type))
      end
    end

    context 'with array of content types' do
      subject(:middleware) do
        described_class.new(app, content_type: content_types)
      end

      let(:content_types) { ['application/json', 'application/vnd.api+json'] }

      it 'raises no errors' do
        content_types.each do |content_type|
          middleware.call(env.merge('CONTENT_TYPE' => content_type))
        end
      end
    end

    context 'with regex as content type' do
      subject(:middleware) do
        described_class.new(app, content_type: content_type_regex)
      end

      let(:content_type_regex) { %r{application/(vnd\.api\+)?json($|;)} }

      let(:content_types) do
        [
          'application/json',
          'application/vnd.api+json',
          'application/vnd.api+json; ext=foobar'
        ]
      end

      it 'raises no errors' do
        content_types.each do |content_type|
          middleware.call(env.merge('CONTENT_TYPE' => content_type))
        end
      end
    end

    context 'with invalid content type' do
      it 'raises an InvalidContentTypeError' do
        expect { middleware.call(env.merge('CONTENT_TYPE' => 'invalid')) }.to(
          raise_error(Rack::JSONParser::InvalidContentTypeError)
        )
      end
    end

    context 'with ContentLength header unset' do
      let(:env) { { 'rack.input' => body } }
      let(:body_string) { nil }

      it 'responds with the apps result without error' do
        expect(middleware.call(env)).to eq([200, nil, 'test'])
      end
    end
  end
end
