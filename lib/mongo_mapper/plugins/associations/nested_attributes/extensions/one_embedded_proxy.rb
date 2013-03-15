module MongoMapper
  module Plugins
    module Associations

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

    end
  end
end