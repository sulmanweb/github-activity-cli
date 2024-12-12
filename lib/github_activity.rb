require_relative 'github_client'
require_relative 'activity_formatter'

class GitHubActivity
  def initialize(username)
    @username = username
    @client = GitHubClient.new
    @formatter = ActivityFormatter.new
  end

  def run
    events = @client.fetch_user_events(@username)
    if events.empty?
      puts "No recent activity found for user '#{@username}'"
      return
    end

    puts "\nRecent GitHub activity for #{@username}:"
    puts "-" * 50
    events.each do |event|
      formatted_event = @formatter.format(event)
      puts formatted_event if formatted_event
    end
  end
end
