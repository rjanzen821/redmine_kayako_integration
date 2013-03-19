require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RedmineKayako do 
	let(:worker){ RedmineKayako.new}
	it "has a default department" do
		worker.setup
		worker.kayako_department.should == 3
	end
	it "has a default redmine issue identifier" do
		worker.setup
	    worker.kayako_issue_field_identifier.should == '2azuubvzms0b'
	end
end