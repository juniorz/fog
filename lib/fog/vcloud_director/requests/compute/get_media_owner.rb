module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the owner of a media object.
        #
        # @param [String] id Object identifier of the media object.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MediaOwner.html
        # @since vCloud API version 1.5
        def get_media_owner(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "media/#{id}/owner"
          )
        end
      end

      class Mock
        def get_media_owner(id)
          unless media = data[:medias][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"com.vmware.vcloud.entity.media:#{id}\"."
            )
          end

          Fog::Mock.not_implemented
          media.is_used_here # avoid warning from syntax checker
        end
      end
    end
  end
end
