require 'bundler'
Bundler.setup

require 'rspec'
require 'mongo_mapper'

load File.expand_path('../../lib/mm-nested-attributes.rb', __FILE__)

RSpec.configure do |c|
  def Doc(name=nil, &block)
    klass = Class.new do
      include MongoMapper::Document
      set_collection_name :test

      if name
        class_eval "def self.name; '#{name}' end"
        class_eval "def self.to_s; '#{name}' end"
      end
    end

    klass.class_eval(&block) if block_given?
    klass.collection.remove
    klass
  end

  def EDoc(name=nil, &block)
    klass = Class.new do
      include MongoMapper::EmbeddedDocument

      if name
        class_eval "def self.name; '#{name}' end"
        class_eval "def self.to_s; '#{name}' end"
      end
    end

    klass.class_eval(&block) if block_given?
    klass
  end

  def doing(&block)
    block
  end

  MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
  MongoMapper.database = "mm-nested-attributes-test-#{RUBY_VERSION.gsub('.', '-')}"
  MongoMapper.database.collections.each { |c| c.drop_indexes }
end

class TestParent
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Associations::NestedAttributes

  many :test_children
  one :test_solo
  belongs_to :test_one

  key :name, String

  accepts_nested_attributes_for :test_children, :test_solo, :test_one

  validates_presence_of :name
end

class TestChild
  include MongoMapper::Document

  belongs_to :test_parent

  key :name, String
end

class TestSolo
  include MongoMapper::Document

  belongs_to :test_parent

  key :name, String
end

class TestOne
  include MongoMapper::Document

  one :test_parent

  key :name, String
end