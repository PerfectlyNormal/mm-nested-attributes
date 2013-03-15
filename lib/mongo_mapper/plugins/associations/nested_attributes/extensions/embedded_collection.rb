module MongoMapper
  module Plugins
    module Associations

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