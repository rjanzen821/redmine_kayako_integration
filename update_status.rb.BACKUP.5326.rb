<<<<<<< HEAD
require 'kayako_client'
require 'active_resource'
require 'logger'

KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
  #kayko api info here
end

class Issue < ActiveResource::Base # Redmine API configuration and Issue model
#redmine info here
end

KayakoClient::Base.configure do |config| #logger config
    config.logger = Logger.new(STDOUT)
end

tickets = KayakoClient::Ticket.all(3) #Get kayako custom field contents
postString = "" #declare string to be posted back to Kayako
tickets.each do |ticket|
	fields = KayakoClient::TicketCustomField.get(ticket.id)
  red_idAray = fields['2azuubvzms0b'].scan(/\b\d{1}\b/) #parse redmine ids /(d+/d)+)/
    red_idAray.each do |red_id|
       if Issue.exists?(red_id) == true
       red_status = Issue.find(red_id).status.name #get current redmine status
       postString += "##{red_id}|#{red_status}|   " #rebuild kayako custom field string
       else
        postString += "##{red_id}|NA|   " #handle non-existent redmine issues
        end
      end
  fields['2azuubvzms0b'] = postString #post updated kayako custom field string
  fields.post
=======
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
class Issue < ActiveResource::Base # Redmine API configuration and Issue model
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
  kayako_custom_fields[kayako_issue_field_identifier] = redmine_issue_ids.map{|id| Issue.exists?(id) ? "##{id}|#{Issue.find(id).status.name}|" : "##{id}|NA|" }.join("  ")
  # post updated kayako custom field string
  kayako_custom_fields.post
>>>>>>> 04b0650a1b15b5d72f09a499db489021d3c8843e
end