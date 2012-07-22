require 'spec_helper'
# Specs in this file have access to a helper object that includes
# the AjaxViewHelper. For example:
#
describe AjaxViewHelper do
  describe "ajax_body" do
    it "should generate a proper html" do
      block = lambda {TestData::CONTENT}
      helper.ajax_body(&block).should == TestData::AJAX_BODY
    end
  end
  describe "ajax_container" do
    it "should generate a proper html" do
      block = lambda {TestData::CONTENT}
      args = TestData::CONTAINER_PARAMS
      helper.ajax_container(args,&block).should == TestData::CONTAINER_BODY
    end
  end
  describe "ajax_link" do
    it "should generate a proper html" do
    
    end
  end
  describe "ajax_button" do
    it "should generate a proper html" do
    
    end
  end
end

