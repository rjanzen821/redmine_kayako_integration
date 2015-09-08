require "rubygems"
require "bundler/setup"
require "kayako_client"
require "active_resource"
require "logger"

KayakoClient::Base.configure do |config| #logger config
      config.logger = Logger.new(STDOUT)
end

class RedmineIssue < ActiveResource::Base # Redmine API configuration and Issue model
end

class RedmineKayako
  attr_accessor :kayako_department
  attr_accessor :kayako_issue_field_identifier
  attr_accessor :credentials


  def initialize(configfile, fieldid = 'zo7wdtu1ze9a', department = 1)
    # Kayako setup
    self.kayako_department = department
    self.kayako_issue_field_identifier = fieldid
    self.credentials = YAML.load File.read(configfile)
    
    RedmineIssue.site     = credentials['redmine']['url']
    RedmineIssue.user     = credentials['redmine']['user']
    RedmineIssue.password = credentials['redmine']['password']
    RedmineIssue.format   = :xml
   
    # @todo fix this
    #KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
    #  config.api_url    =  credentials['kayako']['url']
    #  config.api_key    =  credentials['kayako']['api_key']
    #  config.secret_key =  credentials['kayako']['api_secret']
    #end

    # Redmine setup
  #class RedmineIssue < ActiveResource::Base # Redmine API configuration and Issue model
      # redmine info here

   # end

  end

  def update_kayako
    KayakoClient::Ticket.all(self.kayako_department).each do |ticket|
    	# Get kayako custom field contents
      kayako_custom_fields = KayakoClient::TicketCustomField.get(ticket.id)
      # extract redmine ids
      redmine_issue_ids = kayako_custom_fields[self.kayako_issue_field_identifier].scan(/\#(\d+)/).flatten.map(&:to_i)
      # assemble a string of redmine ids and statuses, e.g. "#123|open|  #957|closed|"
      kayako_custom_fields[self.kayako_issue_field_identifier] = redmine_issue_ids.map{|id| RedmineIssue.exists?(id) ? "##{id}|#{RedmineIssue.find(id).status.name}|" : "##{id}|NA|" }.join("  ")
      # post updated kayako custom field string
      kayako_custom_fields.post
    end
  end
end
