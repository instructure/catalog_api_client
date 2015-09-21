require 'catalog/api/version'
require 'rest-client'
require 'securerandom'
require 'link_header'

module Catalog
  module Api
    class Client
      def initialize(opts = {})
        if opts[:host].include? ':'
          @host, @port = opts[:host].split(':')
        else
          @host = opts[:host]
        end
        @scheme = opts[:scheme] || 'https'
        @port ||= (@scheme == 'https') ? 443 : 80
        @token = opts[:token]
        @version = opts[:version] || 'v1'
        @auth_header = {
          Authorization: "Token token=#{@token}",
          content_type: 'application/json'
        }
        @api_path = "/api/#{@version}"
      end

      def uri(resource, resource_id = nil)
        URI::Generic.build(
          scheme: @scheme,
          host:   @host,
          port:   @port.to_i,
          path: [@api_path, resource, resource_id].compact.join('/')
        ).to_s
      end

      [:get, :post, :put, :delete].each do |method|
        define_method method do |resource, options = { resource_id: nil, request_body: nil }|
          if (method.eql? :get) && (options[:resource_id].nil?)
            paginated_api_request(resource, options[:max_pages])
          else
            api_request(method, resource, options)
          end
        end
      end

      def api_request(method, resource, options)
        path = uri(resource, options[:resource_id])
        response = call_api(method, path, options[:request_body])
        p_response = process_response response
        (p_response.is_a?(Hash) && p_response.size == 1) ? p_response.first.last : p_response
      end

      def paginated_api_request(resource, max_pages)
        data ||= []
        cur_page_index = 0
        path = uri(resource)
        while path && evaluate_page(cur_page_index, max_pages)
          response = call_api(:get, path)
          p_response = process_response response
          if p_response.is_a?(Hash)
            data += p_response[resource]
          else
            data = p_response
            break
          end
          path = next_page(response)
          cur_page_index += 1 unless path.nil?
        end
        data
      end

      private

      def evaluate_page(cur_page_index, max_page)
        if max_page.nil?
          true
        elsif cur_page_index < max_page
          true
        else
          false
        end
      end

      def process_response(response)
        (response.nil? || response == '') ? response : JSON.parse(response)
      end

      def call_api(method, path, request_body=nil)
        case method
        when :delete, :get
          RestClient.send(method, path, @auth_header)
        when :post, :put
          RestClient.send(method, path, request_body, @auth_header)
        else
          fail "Invalid method: #{method}"
        end
      end

      def next_page(response)
        links = LinkHeader.parse(response.headers[:link]).links
        if next_link = links.find { |link| link['rel'] == 'next' }
          next_link.href
        end
      end
    end
  end
end
