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

      [:get, :post, :put, :delete].each do |method|
        define_method method do |resource, options = { resource_id: nil, request_body: nil }|
          delegate(method, resource, options)
        end
      end

      private

      def delegate(method, resource, options)
        paginate?(method, options) ? paginated_request(options, resource) : request(method, resource, options)
      end

      def paginate?(method, options)
        (method.eql? :get) && (options[:resource_id].nil?)
      end

      def request(method, resource, options)
        path = uri(resource, options[:resource_id])
        call_api(method, path, options[:request_body]).last # return response body w/o header
      end

      def paginated_request(options, resource)
        path = uri(resource)
        headers, body = call_api(:get, path)
        return body if body.empty?

        cur_page_index = 1
        path = next_page(headers)
        while path && pages?(cur_page_index, options[:max_pages])
          headers, paginated_body = call_api(:get, path)
          body.concat paginated_body
          cur_page_index += 1
          path = next_page(headers)
        end

        body
      end

      def uri(resource, resource_id = nil)
        URI::Generic.build(
          scheme: @scheme,
          host:   @host,
          port:   @port.to_i,
          path:   [@api_path, resource, resource_id].compact.join('/')
        ).to_s
      end

      def headers_and_body(response)
        parsed_response = JSON.parse(response) rescue {}
        headers = response.headers
        body = if parsed_response.size == 1
                 parsed_response.first.last
               else
                 parsed_response
               end
        [headers, body]
      end

      def pages?(cur_page_index, max_page)
        max_page.nil? || cur_page_index < max_page
      end

      def call_api(method, path, request_body = nil)
        response =
        case method
        when :delete, :get
          RestClient.send(method, path, @auth_header)
        when :post, :put
          RestClient.send(method, path, request_body, @auth_header)
        else
          fail "Invalid method: #{method}"
        end
        headers_and_body(response)
      end

      def next_page(headers)
        links = LinkHeader.parse(headers[:link]).links
        next_link = links.find { |link| link['rel'] == 'next' } and next_link.href
      end
    end
  end
end
