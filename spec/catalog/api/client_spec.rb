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
        expect(courses).to be_empty
      end
    end

    context 'pagination' do
      let(:course_response_page_1) { '{"courses":[{"id":1},{"id":2},{"id":3},{"id":4},{"id":5},{"id":6},{"id":7},{"id":8},{"id":9},{"id":10},{"id":11},{"id":12},{"id":13},{"id":14},{"id":15},{"id":16},{"id":17},{"id":18},{"id":19},{"id":20}]}' }
      let(:course_response_page_2) { '{"courses":[{"id":21},{"id":22},{"id":23},{"id":24},{"id":25},{"id":26},{"id":27},{"id":28},{"id":29},{"id":30},{"id":31},{"id":32},{"id":33},{"id":34},{"id":35},{"id":36},{"id":37},{"id":38},{"id":39},{"id":40}]}' }
      let(:course_response_page_3) { '{"courses":[{"id":41},{"id":42},{"id":43},{"id":44},{"id":45},{"id":46},{"id":47},{"id":48},{"id":49},{"id":50},{"id":51},{"id":52},{"id":53},{"id":54},{"id":55},{"id":56},{"id":57},{"id":58},{"id":59},{"id":60}]}' }
      it 'follows link headers and fetches all pages by default' do
        stub_request(:get, /www.example.com/)
            .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=3>; rel="last", <https://www.example.com/api/v1/courses/?page=1>; rel="next"' }, body: course_response_page_1)
            .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=3>; rel="last", <https://www.example.com/api/v1/courses/?page=2>; rel="next"' }, body: course_response_page_2)
            .to_return( body: course_response_page_3)
        courses = client.get('courses')
        expect(courses.uniq.count).to be == courses.count
        expect(courses.size).to be == 60
      end
      it 'allows passing in a max_pages limit' do
        stub_request(:get, /www.example.com/)
          .with(headers: { Authorization: "Token token=#{token}" })
            .to_return(headers: { link: '<https://www.example.com/api/v1/courses/?page=2>; rel="last", <https://www.example.com/api/v1/courses/?page=2>; rel="next"' },
                       body: course_response_page_1)
            .to_return(body: course_response_page_2)
        courses = client.get('courses', max_pages: 1)
        expect(courses.uniq.count).to be == courses.count
        expect(courses.size).to be == 20
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
