require 'mongo_mapper'
require 'mm-nested-attributes/version'
require 'mongo_mapper/plugins/associations/nested_attributes'
require 'mongo_mapper/plugins/associations/nested_attributes/destructable'
require 'mongo_mapper/plugins/associations/nested_attributes/extensions/associations'
require 'mongo_mapper/plugins/associations/nested_attributes/extensions/many_documents_proxy'
require 'mongo_mapper/plugins/associations/nested_attributes/extensions/belongs_to_proxy'
require 'mongo_mapper/plugins/associations/nested_attributes/extensions/one_embedded_proxy'
require 'mongo_mapper/plugins/associations/nested_attributes/extensions/embedded_collection'

module MongoMapper
  module Plugins
    module Document
      include MongoMapper::Plugins::Associations::NestedAttributes::Destructable
    end

    module EmbeddedDocument
      include MongoMapper::Plugins::Associations::NestedAttributes::Destructable
    end
  end
end