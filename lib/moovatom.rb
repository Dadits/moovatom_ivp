# :title: MoovAtom API Documentation
# The MoovEngine API provides the RESTful interface for encoding, canceling
# and querying, your videos on the MoovAtom servers. This library defines the
# methods and functionality necessary for your app to communicate with that
# interface.
#
# See README file for installation details and general usage information.
#
# Author:: Dominic Giglio <mailto:humanshell@gmail.com>
# Copyright:: Copyright (c) 2012 Dominic Giglio - All Rights Reserved
# License:: MIT

#-- required gems/libraries
%w[net/https rexml/document builder uri].each { |item| require item }

#-- wrap the whole library in a module to enforce namespace
module MoovAtom
  
  #-- MoovAtom module constants
  API_URL_V1  = 'https://moovatom.com/api/api_request'
  API_URL_V2  = 'https://www.moovatom.com/api/v2'
  
  class MoovEngine
    
    #-- class setters and getters
    attr_reader :xml_response
    attr_accessor :guid, :username, :userkey, :content_type, :title, :blurb,
                  :sourcefile, :callbackurl
    
    # The initializer populates the instance variables to hold all the
    # specifics about the video you're accessing. You can define these
    # variables when instantiating a new MoovEngine object or after a blank
    # object has been created. All variables with the exception of
    # @xml_response and @action are writable. @xml_response is only readable
    # because it contains the response from MoovAtom's servers. @action gets
    # set in each of the methods below to correctly correspond with the
    # associated request.
    #
    # Usage:
    #
    def initialize(args={})
    end #-- initialize method
    
    # Use this method to get the details about a video that's finished
    # encoding. This method requires @username, @userkey and @guid to be set.
    #
    # If @guid has not been set then you can pass it in as a string argument.
    #
    # Usage:
    #
    def details(guid = "")
      @action = 'details'
    end #-- details method
    
    # Use this method to get the status of a video that is currently being
    # encoded. This method requires @username, @userkey and @guid to be set.
    #
    # If @guid has not been set then you can pass it in as a string argument.
    #
    # Usage:
    #
    def status(guid = "")
      @action = 'status'
    end #-- end status method
    
    # Use this method to start encoding a new video.
    # This method requires the following variables be set:
    # * @username
    # * @userkey
    # * @content_type
    # * @title
    # * @blurb
    # * @sourcefile
    # * @callbackurl
    #
    # Usage:
    #
    def encode
      @action = 'encode'
    end #-- encode method
    
    # Use this method to cancel the encoding of a video.
    # This method requires @username, @userkey and @guid to be set.
    #
    # If @guid has not been set then you can pass it in as a string argument.
    #
    # Usage:
    #
    def cancel(guid = "")
      @action = 'cancel'
    end #-- cancel method
    
    #-- start of private methods
    private
    
    # Creates the XML object that is post'd to the MoovAtom servers
    def build_xml_request
      b = Builder::XmlMarkup.new
      b.instruct!
      xml = b.request do |r|
        r.uuid(@guid)
        r.username(@username)
        r.userkey(@userkey)
        r.action(@action)
        r.content_type(@content_type)
        r.title(@title)
        r.blurb(@blurb)
        r.sourcefile(@sourcefile)
        r.callbackurl(@callbackurl)
      end
    end #-- build_xml_request method
    
    # Sends the XML object to the MoovAtom servers
    def send_xml_request(xml, url = MoovAtom::API_URL_V2)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.post(uri.request_uri, "xml=#{URI.escape(xml)}")
    end #-- send_xml_request method
    
  end #-- MoovEngine class
  
end #-- MoovAtom module

