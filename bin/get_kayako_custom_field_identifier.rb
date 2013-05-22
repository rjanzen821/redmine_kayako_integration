require "rubygems"
require "bundler/setup"
require "kayako_client"
require "active_resource"
require "logger"

#KayakoClient::Base.configure do |config| #logger config
#      config.logger = Logger.new(STDOUT)
#end
class FieldIDs

  def credentials
    #api creds
    YAML.load File.read 'config.yml'
  end

  def setup
    KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
      config.api_url    =  credentials['kayako']['url']
      config.api_key    =  credentials['kayako']['api_key']
      config.secret_key =  credentials['kayako']['api_secret']
    end
  end

  def get_custom_field_id
    #print custom field title and name aka field_identifier for each custom field
    KayakoClient::CustomField.all.each do |custom_field_attributes| 
      puts custom_field_attributes.title
      puts custom_field_attributes.fieldname
    end
  end
end
