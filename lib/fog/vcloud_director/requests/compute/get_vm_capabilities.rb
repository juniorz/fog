module Fog
  module Compute
    class VcloudDirector
      class Real
        # Gets capabilities for the VM identified by id.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VmCapabilities.html
        def get_vm_capabilities(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/vmCapabilities"
          )
        end
      end
    end
  end
end
