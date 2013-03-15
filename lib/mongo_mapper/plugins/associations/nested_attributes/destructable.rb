module MongoMapper
  module Plugins
    module Associations
      module NestedAttributes
        module Destructable
          def mark_for_destruction
            @marked_for_destruction = true
          end

          def marked_for_destruction?
            @marked_for_destruction
          end
        end
      end
    end
  end
end