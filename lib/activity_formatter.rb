class ActivityFormatter
  def format(event)
    case event['type']
    when 'PushEvent'
      format_push_event(event)
    when 'CreateEvent'
      format_create_event(event)
    when 'IssuesEvent'
      format_issues_event(event)
    when 'WatchEvent'
      format_watch_event(event)
    when 'ForkEvent'
      format_fork_event(event)
    when 'PullRequestEvent'
      format_pull_request_event(event)
    else
      nil
    end
  end

  private

  def format_push_event(event)
    commits_count = event.dig('payload', 'commits')&.size || 0
    repo_name = event.dig('repo', 'name')
    "Pushed #{commits_count} commit#{commits_count == 1 ? '' : 's'} to #{repo_name}"
  end

  def format_create_event(event)
    ref_type = event.dig('payload', 'ref_type')
    repo_name = event.dig('repo', 'name')
    "Created #{ref_type} in #{repo_name}"
  end

  def format_issues_event(event)
    action = event.dig('payload', 'action')
    issue_title = event.dig('payload', 'issue', 'title')
    repo_name = event.dig('repo', 'name')
    "#{action.capitalize} issue '#{issue_title}' in #{repo_name}"
  end

  def format_watch_event(event)
    repo_name = event.dig('repo', 'name')
    "Starred #{repo_name}"
  end

  def format_fork_event(event)
    repo_name = event.dig('repo', 'name')
    "Forked #{repo_name}"
  end

  def format_pull_request_event(event)
    action = event.dig('payload', 'action')
    pr_title = event.dig('payload', 'pull_request', 'title')
    repo_name = event.dig('repo', 'name')
    "#{action.capitalize} pull request '#{pr_title}' in #{repo_name}"
  end
end
