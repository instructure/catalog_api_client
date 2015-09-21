require 'spec_helper'

describe 'client' do
  let(:token) { 'J9hnR0naldReuelT2lkien' }
  let(:host) { 'www.example.com' }
  let(:client) { Catalog::Api::Client.new(host: host, token: token) }
  let(:course_id) { 152_436 }
  describe 'get' do
    context 'with a resource ID' do
      it 'requests the show action' do
        stub_request(:get, "https://www.example.com/api/v1/courses/#{course_id}")
          .with(headers: { Authorization: "Token token=#{token}" })
          .to_return(status: 200,
                     body: '{"course":{"id": 20,"visibility": "listed","canvas_course": { "id": 991092 }}}')
        course = client.get('courses', resource_id: course_id)
        expect(course).to be
        expect(course['canvas_course']['id']).to eql 991092
      end
    end

    context 'without a resource ID' do
      it 'requests the index action' do
        stub_request(:get, 'https://www.example.com/api/v1/courses')
          .with(headers: { Authorization: "Token token=#{token}" })
          .to_return(status: 200)
        courses = client.get('courses')
        expect(courses).to be
        expect(courses.size).to be == 0
      end
    end

    context 'pagination' do
      let(:course_response) { '{"courses":[{"id":270,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.99","created_at":"2015-07-14T18:43:25.285Z","updated_at":"2015-07-14T18:43:25.285Z","short_description":"Api created course for testing","listing_path":"course-paypalhappy-d321fabe09a6050b4a58a584e9a8e4c5","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalHappy-d321fabe09a6050b4a58a584e9a8e4c5","list_order":null,"waitlist":false,"canvas_course":{"id":61}},{"id":273,"visibility":"listed","enrollment_open":true,"enrollment_cap":12,"description":"catauto59885a991a95fb3b26693edaadd44456","enrollment_fee":"0.99","created_at":"2015-07-14T18:50:25.240Z","updated_at":"2015-09-22T14:48:48.761Z","short_description":"catauto teaser","listing_path":"catauto59885a991a95fb3b26693edaadd44456","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"catauto59885a991a95fb3b26693edaadd44456","list_order":null,"waitlist":false,"canvas_course":{"id":64}},{"id":274,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"105.39","created_at":"2015-07-14T18:50:33.259Z","updated_at":"2015-07-14T18:50:33.259Z","short_description":"Api created course for testing","listing_path":"course-paypalreject-dc5ca8e48153f11e2f82f205faf38c3b","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalReject-dc5ca8e48153f11e2f82f205faf38c3b","list_order":null,"waitlist":false,"canvas_course":{"id":65}},{"id":277,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.99","created_at":"2015-07-14T19:01:32.620Z","updated_at":"2015-07-14T19:01:32.620Z","short_description":"Api created course for testing","listing_path":"course-paypalhappy-0758e8cccaf24bf66f6dd529a59b8c9a","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalHappy-0758e8cccaf24bf66f6dd529a59b8c9a","list_order":null,"waitlist":false,"canvas_course":{"id":68}},{"id":278,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.99","created_at":"2015-07-14T19:42:33.970Z","updated_at":"2015-07-14T19:42:33.970Z","short_description":"Api created course for testing","listing_path":"course-paypalhappy-ba39d93dcf86926982ccbef158421d0a","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalHappy-ba39d93dcf86926982ccbef158421d0a","list_order":null,"waitlist":false,"canvas_course":{"id":69}},{"id":280,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:47:29.762Z","updated_at":"2015-07-14T19:47:29.762Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-b997a533fbf1ad96c4a42db8ff678d15","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-b997a533fbf1ad96c4a42db8ff678d15","list_order":null,"waitlist":false,"canvas_course":{"id":70}},{"id":281,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:48:48.217Z","updated_at":"2015-07-14T19:48:48.217Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-7e57694c780417f3031f1ef00a2f289f","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-7e57694c780417f3031f1ef00a2f289f","list_order":null,"waitlist":false,"canvas_course":{"id":71}},{"id":282,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.99","created_at":"2015-07-14T19:50:03.842Z","updated_at":"2015-07-14T19:50:03.842Z","short_description":"Api created course for testing","listing_path":"course-paypalcancel-25ee024b634c4860eb6694ac71526ede","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalCancel-25ee024b634c4860eb6694ac71526ede","list_order":null,"waitlist":false,"canvas_course":{"id":72}},{"id":283,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.99","created_at":"2015-07-14T19:50:39.676Z","updated_at":"2015-07-14T19:50:39.676Z","short_description":"Api created course for testing","listing_path":"course-paypalhappy-8bea05dfb49ac183ae32919877eb4a12","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalHappy-8bea05dfb49ac183ae32919877eb4a12","list_order":null,"waitlist":false,"canvas_course":{"id":73}},{"id":284,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"105.39","created_at":"2015-07-14T19:50:47.230Z","updated_at":"2015-07-14T19:50:47.230Z","short_description":"Api created course for testing","listing_path":"course-paypalreject-8cd0752145e2d2426ee465bf05c96ad8","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-PaypalReject-8cd0752145e2d2426ee465bf05c96ad8","list_order":null,"waitlist":false,"canvas_course":{"id":74}},{"id":285,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:50:49.161Z","updated_at":"2015-07-14T19:50:49.161Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-29027f2fe7411ffea840e9fbe90d86b9","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-29027f2fe7411ffea840e9fbe90d86b9","list_order":null,"waitlist":false,"canvas_course":{"id":75}},{"id":286,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:51:25.291Z","updated_at":"2015-07-14T19:51:25.291Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-1a9fd0539e57bde84c5e442a4ba778be","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-1a9fd0539e57bde84c5e442a4ba778be","list_order":null,"waitlist":false,"canvas_course":{"id":76}},{"id":287,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:52:10.050Z","updated_at":"2015-07-14T19:52:10.050Z","short_description":"Api created course for testing","listing_path":"course-cashnet-happy-da59040cb40ea327b5e1ad61c3f7c262","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-happy-da59040cb40ea327b5e1ad61c3f7c262","list_order":null,"waitlist":false,"canvas_course":{"id":77}},{"id":288,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:54:01.326Z","updated_at":"2015-07-14T19:54:01.326Z","short_description":"Api created course for testing","listing_path":"course-cashnet-happy-e76b91c4e14e664fdfc6c78ef79d7b47","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-happy-e76b91c4e14e664fdfc6c78ef79d7b47","list_order":null,"waitlist":false,"canvas_course":{"id":78}},{"id":289,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T19:55:07.082Z","updated_at":"2015-07-14T19:55:07.082Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-efd739544e57d1b7864f0a5e7bbef1ea","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-efd739544e57d1b7864f0a5e7bbef1ea","list_order":null,"waitlist":false,"canvas_course":{"id":79}},{"id":290,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T20:02:04.049Z","updated_at":"2015-07-14T20:02:04.049Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-c6afbb757260b5d66d2c0de79e832329","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-c6afbb757260b5d66d2c0de79e832329","list_order":null,"waitlist":false,"canvas_course":{"id":80}},{"id":291,"visibility":"listed","enrollment_open":true,"enrollment_cap":39,"description":"catauto40fad8d88ce86215db711887053959d3","enrollment_fee":"0.99","created_at":"2015-07-14T20:03:02.164Z","updated_at":"2015-09-29T15:42:15.700Z","short_description":"catauto teaser","listing_path":"catauto40fad8d88ce86215db711887053959d3","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"catauto40fad8d88ce86215db711887053959d3","list_order":null,"waitlist":false,"canvas_course":{"id":12629}},{"id":292,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T20:09:19.772Z","updated_at":"2015-07-14T20:09:19.772Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-3493822fe25249908b683261d586bfbc","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-3493822fe25249908b683261d586bfbc","list_order":null,"waitlist":false,"canvas_course":{"id":82}},{"id":293,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T20:10:33.756Z","updated_at":"2015-07-14T20:10:33.756Z","short_description":"Api created course for testing","listing_path":"course-cashnet-happy-a0e57bb52f2d155436ed53e9a6a54a86","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-happy-a0e57bb52f2d155436ed53e9a6a54a86","list_order":null,"waitlist":false,"canvas_course":{"id":83}},{"id":294,"visibility":"listed","enrollment_open":true,"enrollment_cap":150,"description":"Api created course for testing","enrollment_fee":"0.81","created_at":"2015-07-14T20:11:14.329Z","updated_at":"2015-07-14T20:11:14.329Z","short_description":"Api created course for testing","listing_path":"course-cashnet-reject-ab48b11f8c06315c4a21ecff107bb396","currency":"USD","catalog":{"id":10,"name":"automation.test.catalog.instructure.com"},"type":"Course","title":"course-cashnet-reject-ab48b11f8c06315c4a21ecff107bb396","list_order":null,"waitlist":false,"canvas_course":{"id":84}}]}' }

      it 'follows link headers and fetches all pages by default' do
        stub_request(:get, /www.example.com/)
          .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=4>; rel="last", <https://www.example.com/api/v1/courses/?page=2>; rel="next"' },
                     body: course_response)
          .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=4>; rel="last", <https://www.example.com/api/v1/courses/?page=3>; rel="next"' },
                     body: course_response)
          .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=4>; rel="last", <https://www.example.com/api/v1/courses/?page=4>; rel="next"' },
                     body: course_response)
          .to_return(headers: { link: nil },
                     body: JSON.parse(course_response).to_json)
        courses = client.get('courses')
        expect(courses).to be
        expect(courses.size).to be == 80
      end
      it 'allows passing in a max_pages limit' do
        stub_request(:get, /www.example.com/)
          .with(headers: { Authorization: "Token token=#{token}" })
          .to_return(status: 200,
                     headers: { link: '<https://www.example.com/api/v1/courses/?page=10>; rel="last", <https://www.example.com/api/v1/courses/?page=2>; rel="next"'
                     },
                     body: course_response)
        courses = client.get('courses', max_pages: 3)
        expect(courses).to be
        expect(courses.size).to be == 60
      end
    end
  end

  describe 'post' do
    context 'with a request body' do
      it 'requests the create action' do
        stub_request(:post, 'https://www.example.com/api/v1/courses')
          .with(headers: { Authorization: "Token token=#{token}" })
          .to_return(status: 201,
                     body: '{"course":{"id": 20,"visibility": "listed","canvas_course": { "id": 12 }}}')
        course = client.post('courses', request_body: { course: { title: 'Course 1', canvas_course_id: 214 } })
        expect(course).to be
        expect(course['canvas_course']['id']).to eql 12
      end
    end
  end

  describe 'delete' do
    context 'with a resource id' do
      it 'requests the delete action' do
        stub_request(:delete, "https://www.example.com/api/v1/courses/#{course_id}")
          .with(headers: { Authorization: "Token token=#{token}" })
          .to_return(status: 204)
        client.delete('courses', resource_id: course_id)
      end
      it 'requests the delete action exception' do
        stub_request(:delete, "https://www.example.com/api/v1/courses/#{course_id}")
          .to_raise(RestClient::Exception)
        expect { client.delete('courses', resource_id: course_id) }.to raise_exception(RestClient::Exception)
      end
    end
  end

  describe 'put' do
    context 'with a resource id' do
      it 'requests the update action' do
        stub_request(:put, "https://www.example.com/api/v1/courses/#{course_id}")
          .with(headers: { Authorization: "Token token=#{token}" },
                body: { course: { title: 'Course 1' } })
          .to_return(status: 204)
        client.put('courses', resource_id: course_id, request_body:
                                { course: { title: 'Course 1' } })
      end
    end
  end
end
