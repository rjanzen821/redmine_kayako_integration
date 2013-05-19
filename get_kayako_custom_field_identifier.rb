require "rubygems"
require "bundler/setup"
require "kayako_client"
require "active_resource"
require "logger"

#KayakoClient::Base.configure do |config| #logger config
#      config.logger = Logger.new(STDOUT)
#end

def credentials
  #api creds
  YAML.load File.read 'config.yml'
end

KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
	config.api_url    =  credentials['kayako']['url']
	config.api_key    =  credentials['kayako']['api_key']
	config.secret_key =  credentials['kayako']['api_secret']
end

#print custom field title and name aka field_identifier for each custom field
KayakoClient::CustomField.all.each { |custom_field_attributes| 
	puts custom_field_attributes['title'] 
	puts custom_field_attributes['field_name'] }