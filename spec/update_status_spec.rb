require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RedmineKayako do 
	let(:worker){ RedmineKayako.new}
	it "has a default department" do
		worker.setup
		worker.kayako_department.should == 1
	end
	it "has a default redmine issue identifier" do
		worker.setup
	    worker.kayako_issue_field_identifier.should == '2azuubvzms0b'
	end
	it "can get all kayako custom fields" do
		worker.update_kayako
	    worker.kayako_custom_fields == 'all custom field contents'
	end
end