#!/usr/bin/env ruby

require "spec_helper"
require "alfred"

describe MDLS do

  let :common_mdls do
      mdls = MDLS.new "."
      mdls.instance_variable_set "@metadata", <<-METADATA
kMDItemContentType             = "public.volume"
kMDItemContentTypeTree         = (
    "public.volume",
    "public.folder",
    "public.directory",
    "public.item"
)
kMDItemDisplayName             = "System"
      METADATA
      mdls
  end

  let :mail_mdls do 
    mdls = MDLS.new "."
    mdls.instance_variable_set "@metadata", <<-METADATA
kMDItemAlternateNames          = (
    "110115.emlx"
)
kMDItemAuthorEmailAddresses    = (
    "95555@message.cmbchina.com"
)
kMDItemAuthors                 = (
    "\\U62db\\U5546\\U94f6\\U884c"
)
kMDItemContentType             = "com.apple.mail.emlx"
kMDItemKind                    = "邮件信息"
kMDItemRecipientEmailAddresses = (
    "xxxx@gmail.com",
    "xxxx@me.com"
)
kMDItemRecipients              = (
    "liuxiang921@gmail.com"
)
kMDItemSubject                 = "浪琴"
    METADATA
    mdls 
  end

  let :web_hist_mdls do  
      mdls = MDLS.new "."
      mdls.instance_variable_set "@metadata", <<-METADATA
kMDItemContentType             = "com.apple.safari.history"
kMDItemDisplayName             = "V2EX"
kMDItemKind                    = "Safari 历史记录项目"
kMDItemURL                     = "http://www.v2ex.com/"      
      METADATA
      mdls    

  end

  describe "#[]" do

    context "when property has a scalar value" do
      it "will populate a string value" do
        expect(common_mdls['kMDItemDisplayName']).to eql("System")
      end
    end

    context "when property has a list values" do
      it "will populate a list values" do
        expected = ['public.volume', 'public.folder', 'public.directory', 'public.item']
        expect(common_mdls['kMDItemContentTypeTree']).to eql(expected)
      end
    end
  end

  describe "#content_type" do
    it "will populate conent_type" do
      expect(common_mdls.content_type).to eql('public.volume')
    end

    it "will set @content_type instance variable after call content_type()" do
      common_mdls.content_type
      expect(common_mdls.instance_variable_get("@content_type")).to eql('public.volume')
    end
  end

  describe "#web_history?" do
    context "when it's a .webhistory file" do
      it "will be true" do
        expect(web_hist_mdls.web_history?).to be(true)
      end
    end

    context "when it's a .emlx file" do
      it "will be false" do
        expect(mail_mdls.web_history?).to be(false)
      end
    end
  end

  describe "#web_title" do
    it "has a title" do
      expect(web_hist_mdls.web_title).to eql('V2EX')
    end
  end

  describe "#web_url" do
    it "has aan URL" do
      expect(web_hist_mdls.web_url).to eql('http://www.v2ex.com/')
    end
  end

  describe "#mail?" do
    context "when it's a .emlx file" do
        it 'will be true' do
          expect(mail_mdls.mail?).to be(true)
        end
    end

    context "when it's a .webhistory file" do
        it 'will be false' do
          expect(web_hist_mdls.mail?).to be(false)
        end
    end
  end

  describe "#mail_title" do
    it "has a title" do
      expect(mail_mdls.mail_title).to eql('浪琴')
    end
  end

  describe "#mail_authors" do
    it "has authors" do
      expect(mail_mdls.mail_authors).to eql(['95555@message.cmbchina.com'])
    end
  end

  describe "#mail_recipients" do
    it "has recipients" do
      expect(mail_mdls.mail_recipients).to eql(['xxxx@gmail.com', 'xxxx@me.com'])
    end
  end
end