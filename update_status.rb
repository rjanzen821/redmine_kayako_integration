require "rubygems"
require "bundler/setup"

require "kayako_client"
require "active_resource"
require "logger"

# Kayako setup
kayako_department = 3
kayako_issue_field_identifier = '2azuubvzms0b'
KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
  config.api_url    = # kayako_url
  config.api_key    = # kayako_key
  config.secret_key = # kayako_secret
end

# Redmine setup
class RedmineIssue < ActiveResource::Base # Redmine API configuration and Issue model
  # redmine info here
  self.site     = # redmine_url
  self.user     = # redmine_user
  self.password = # redmine_password
  self.format   = :xml
end

# Logger
KayakoClient::Base.configure do |config| #logger config
  config.logger = Logger.new(STDOUT)
end

KayakoClient::Ticket.all(kayako_department).each do |ticket|
	# Get kayako custom field contents
  kayako_custom_fields = KayakoClient::TicketCustomField.get(ticket.id)
  # extract redmine ids
  redmine_issue_ids = kayako_custom_fields[kayako_issue_field_identifier].scan(/\#(\d+)/).flatten.map(&:to_i)
  # assemble a string of redmine ids and statuses, e.g. "#123|open|  #957|closed|"
  kayako_custom_fields[kayako_issue_field_identifier] = redmine_issue_ids.map{|id| RedmineIssue.exists?(id) ? "##{id}|#{RedmineIssue.find(id).status.name}|" : "##{id}|NA|" }.join("  ")
  # post updated kayako custom field string
  kayako_custom_fields.post
end