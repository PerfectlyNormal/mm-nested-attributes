module MongoMapper
  module Plugins
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
    end
  end
end