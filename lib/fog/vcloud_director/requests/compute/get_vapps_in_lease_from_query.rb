module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves a list of vApps by using REST API general QueryHandler.
        #
        # @param [Hash] options
        # @option options [String] :sortAsc (Sorted by database ID) Sort
        #   results by attribute-name in ascending order. attribute-name cannot
        #   include metadata.
        # @option options [String] :sortDesc (Sorted by database ID) Sort
        #   results by attribute-name in descending order. attribute-name
        #   cannot include metadata.
        # @option options [Integer] :page (1) If the query results span
        #   multiple pages, return this page.
        # @option options [Integer] :pageSize (25) Number of results per page,
        #   to a maximum of 128.
        # @option options [Integer] :offset (0) Integer value specifying the
        #   first record to return. Record numbers < offset are not returned.
        # @return [Excon::Response]
        #   * hash<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :name<~String> - Query name that generated this result set.
        #     * :page<~String> - Page of the result set that this container
        #       holds. The first page is page number 1.
        #     * :pageSize<~String> - Page size, as a number of records or
        #       references.
        #     * :total<~String> - Total number of records or references in the
        #       container.
        #     * :VAppRecord<~Array<Hash>>:
        #       * TODO
        #     * :firstPage<~Integer> - First page in the result set.
        #     * :previousPage<~Integer> - Previous page in the result set.
        #     * :nextPage<~Integer> - Next page in the result set.
        #     * :lastPage<~Integer> - Last page in the result set.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppsInLeaseFromQuery.html
        # @since vCloud API version 1.5
        def get_vapps_in_lease_from_query(options={})
          query = {}
          query[:sortAsc] = options[:sortAsc] if options[:sortAsc]
          query[:sortDesc] = options[:sortDesc] if options[:sortDesc]
          query[:page] = options[:page] if options[:page]
          query[:pageSize] = options[:pageSize] if options[:pageSize]
          query[:offset] = options[:offset] if options[:offset]

          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'vApps/query',
            :query      => query
          )
          response.body[:VAppRecord] = [response.body[:VAppRecord]] if response.body[:VAppRecord].is_a?(Hash)

          %w[firstPage previousPage nextPage lastPage].each do |rel|
            if link = response.body[:Link].detect {|l| l[:rel] == rel}
              href = Nokogiri::XML.fragment(link[:href])
              query = CGI.parse(URI.parse(href.text).query)
              response.body[rel.to_sym] = query['page'].first.to_i
              response.body[:pageSize] ||= query['pageSize'].first.to_i
            end
          end

          response
        end
      end
    end
  end
end
