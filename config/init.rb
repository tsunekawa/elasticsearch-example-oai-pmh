require 'bundler'
Bundler.require
require 'yaml'
require 'json'
require 'fileutils'

config = YAML.load_file("./config/config.yml")

OAI_ACCESS_POINT = config[:oai][:access_point]

MAPPING_JSON = "./config/mapping.json"
HIGHLIGHT_TAG   = "\e[4m"
HIGHLIGHT_CLOSE = "\e[0m"

INDEX_NAME = 'ir'
TYPE_NAME  = 'record'

class Record
  attr_accessor :filename

  class InvalidMetadataError < StandardError
  end

  NAMESPACES = {
    :dc=>"http://purl.org/dc/elements/1.1/",
    :oai_dc=>"http://www.openarchives.org/OAI/2.0/oai_dc/"
  }

  def self.load_file(xml_file)
    if File.exist?(xml_file)
      record = self.new(File.read(xml_file))
      record.filename = xml_file
      record
    else
      raise "#{xml_file} is missing"
    end
  end

  def initialize(xml)
    @doc = Nokogiri::XML.parse(xml)
    if @doc.xpath('//metadata').empty? then
      raise InvalidMetadataError, "invalid record"
    end
  end

  def title
    @title ||= @doc.xpath('//dc:title/text()', NAMESPACES).first.text
  rescue => ex
    byebug
    raise ex
  end

  def creators
    @creator ||= @doc.xpath('//dc:creator/text()', NAMESPACES).map{|i| i.text }
  end

  def subjects
    @subject ||= @doc.xpath('//dc:subject', NAMESPACES).map{|i| i.text }
  end

  def publishers
    @publisher ||= @doc.xpath('//dc:publisher', NAMESPACES).map{|i| i.text }
  end

  def languages
    @language ||= @doc.xpath('//dc:language', NAMESPACES).map{|i| i.text }
  end

  def identifiers
    @identifier ||= @doc.xpath('//dc:identifier', NAMESPACES).map{|i| i.text }
  end

  def type
    @type ||= @doc.xpath('//dc:type', NAMESPACES).map{|i| i.text }.first
  end

  def date
    @date ||= @doc.xpath('//dc:date', NAMESPACES).map{|i| i.text }.first
  end

  def description
    @description ||= @doc.xpath('//dc:description', NAMESPACES).map{|i| i.text }.first
  end


  def to_hash
    {
      :id => identifiers.find{|i| i=~/^http/ },
      :body => {
        :type => type,
        :title => title,
        :creators => creators,
        :subjects => subjects,
        :publishers => publishers,
        :languages => languages,
        :identifiers => identifiers,
        :date => date,
        :description => description
      }
    }
  end
end

