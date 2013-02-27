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
end