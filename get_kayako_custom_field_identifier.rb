require "rubygems"
require "bundler/setup"
require "kayako_client"
require "active_resource"
require "logger"

def credentials
  #api creds
  YAML.load File.read 'config.yml'
end

KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
	  config.api_url    =  credentials['kayako']['url']
      config.api_key    =  credentials['kayako']['api_key']
      config.secret_key =  credentials['kayako']['api_secret']
end
#gets custom field name to be manually set to self.kayako_issue_field_identifier
KayakoClient::Ticket.all(1).each do |ticket|
	available_fields = KayakoClient::CustomField.all
	puts available_fields.to_s
end
