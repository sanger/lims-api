require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-core/labels/labellable'

module Lims::Core
  module Labels
    class Labellable

      class CreateLabelResource < Lims::Api::CoreActionResource

        def filtered_attributes
          super.mash do |k,v|
            case k
            when :labellable
              [:labellable_uuid,  @context.uuid_for(v)]
            else
              [k,v]
            end
          end
        end
      end

    end
  end
end