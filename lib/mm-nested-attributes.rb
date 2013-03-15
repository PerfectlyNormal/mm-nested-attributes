require 'mm-nested-attributes/version'
require 'mongo_mapper/plugins/associations/nested_attributes'
require 'mongo_mapper/plugins/associations/nested_attributes/destructable'

module MongoMapper
  module Plugins
    module Document
      include MongoMapper::Plugins::Associations::NestedAttributes::Destructable
    end

    module EmbeddedDocument
      include MongoMapper::Plugins::Associations::NestedAttributes::Destructable
    end

    module Associations
      class Base
        def many?
          false
        end

        def one?
          false
        end
      end

      class ManyAssociation
        def many?
          true
        end
      end

      class BelongsToAssociation
        def one?
          true
        end
      end

      class ManyDocumentsProxy
        def save_to_collection(options={})
          if @target
            to_delete = @target.dup.reject { |doc| !doc.marked_for_destruction? }
            @target -= to_delete

            to_delete.each { |doc| doc.destroy }
            @target.each   { |doc| doc.save(options) }
          end
        end
      end

      class BelongsToProxy
        def save_to_collection(options={})
          if @target
            if @target.marked_for_destruction?
              @target.destroy
            else
              @target.save(options)
            end
          end
        end
      end

      class OneEmbeddedProxy
        def save_to_collection(options={})
          if @target
            if @target.marked_for_destruction?
              @target = nil
            else
              @target.persist(options)
            end
          end
        end
      end

      class EmbeddedCollection
        def save_to_collection(options={})
          if @target
            @target.delete_if(&:marked_for_destruction?)
            @target.each{|doc| doc.persist(options)}
          end
        end
      end
    end
  end
end