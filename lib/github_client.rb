require 'net/http'
require 'json'
require 'uri'

class GitHubClient
  BASE_URL = 'https://api.github.com'

  def fetch_user_events(username)
    uri = URI("#{BASE_URL}/users/#{username}/events")
    
    response = make_request(uri)
    
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPNotFound
      raise "User '#{username}' not found"
    else
      raise "Failed to fetch GitHub activity: #{response.message}"
    end
  end

  private

  def make_request(uri)
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/vnd.github.v3+json'
    request['User-Agent'] = 'Ruby GitHub Activity CLI'

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
