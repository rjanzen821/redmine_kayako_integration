#Your username: admin
#Your password: 9mbs27qoat
require 'rubygems'
require 'kayako_client'
require 'active_resource'
require 'logger'

KayakoClient::Base.configure do |config| # Kayako API Configuration uses kayako_client gem
    config.api_url    = 'http://randy.kayako.com/api/'
    config.api_key    = 'c4bab230-f819-b414-4922-6191b6749b94'
    config.secret_key = 'MGEwZjQ2NWMtY2ExNS03NzU0LTkxNTEtNmQ4OGJmY2UxMzQzMzRlMDhkZjMtNjI2Mi04MDc0LTM1YzYtZGQxYjcxMjk1M2I2'
end

class Issue < ActiveResource::Base # Redmine API configuration and Issue model
  self.site = 'http://new-server-1718d9.bitnamiapp.com/redmine'
  self.user = 'user'
  self.password = 'j5lQ4AoDJr3+'
  self.format = :xml
end

#KayakoClient::Base.configure do |config|
#    config.logger = Logger.new(STDOUT)
#end

#Get kayako custom field contents
tickets = KayakoClient::Ticket.all(3)
tickets.each do |ticket|
	fields = KayakoClient::TicketCustomField.get(ticket.id)
  postString = ""
  red_idAray = fields['2azuubvzms0b'].scan(/\b\d{1}\b/) #parse redmine ids
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
end