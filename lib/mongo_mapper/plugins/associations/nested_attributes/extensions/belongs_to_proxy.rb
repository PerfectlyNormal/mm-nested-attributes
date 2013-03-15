module MongoMapper
  module Plugins
    module Associations

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

    end
  end
end