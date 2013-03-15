module MongoMapper
  module Plugins
    module Associations

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

    end
  end
end