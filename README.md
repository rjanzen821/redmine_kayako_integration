This program will provide redmine issue status updates to the Kayako helpdesk.  Kayako tickets are related to redmine issues when a Kayako user adds redmine issue numbers to the custom field in a ticket designated for redmine issue numbers.

The scipt is designed to run every 3,5,15 minutes? a which time it will get redmine issue numbers from Kayako, check redmine for status updates, and finally re-write the Kayako custom fields with new redmine statuses.  The custom field in Kayako contains both the redmine issue and status in the following format:  #3452|open|#4329|closed|






if fields && !fields.empty?

##update recent update time in kayako only ofter red update, not after every cron
	#$_SWIFT_TicketObject->UpdatePool('lastactivity', DATENOW);
	
##Kayako tickets reference MANY redmine issues from 'Public' project and 'Private'

