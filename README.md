# Catalog Api Client

A ruby client for the [Canvas Catalog API](https://api.catalog.instructure.com/api/docs)

## Authentication
Visit `[your-catalog-domain]/admin/api_keys` to create an API key.
To authenticate, set the API key in the constructor. (see Usage section)

## Pagination
All index endpoints support pagination. By default, returns all data.

If no items exist for the requested page, the response will be a root key with an empty array.

You can also specify max_pages. (see Usage section)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'catalog-api-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install catalog-api-client

## Usage

Set up catalog client

    @client = Catalog::Api::Client.new(host: 'gallery.dev:4000', token: 'abc123')

Get courses

    courses = @client.get('courses')
    courses = @client.get('courses', max_pages: 3)

Get course

    courses = @client.get('courses', resource_id: course_id)

Create a course

    course = @client.post('courses', request_body: course_config.request_body)

Update a course

    @client.put('courses', { resource_id: course_id, request_body: course_config.request_body })

Delete a course

    @client.delete('courses', resource_id: course_id)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

For testing purposes only.


The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).