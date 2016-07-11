require 'spec_helper'
require 'core_ext/hash_extension'

describe Hash do
  describe '.mm_underscore_keys' do
    it 'handles a single element' do
      subject = { userRef: 'shouldBeSame' }

      expect(subject.mm_underscore_keys).to eq(user_ref: 'shouldBeSame')
    end

    it 'handles multiple key/value pairs' do
      subject = { userRef: 'shouldBeSame', fooBar: 'fooBar' }

      expect(subject.mm_underscore_keys).to eq(user_ref: 'shouldBeSame',
                                               foo_bar: 'fooBar')
    end

    it 'handles a nested hash' do
      subject = { userRef: 'shouldBeSame',
                  nestedFoo: { innerFoo: 'shouldBeSame' } }

      expect(subject.mm_underscore_keys).to eq(
        user_ref: 'shouldBeSame',
        nested_foo: { inner_foo: 'shouldBeSame' }
      )
    end

    it 'handles an array of hashes' do
      subject = { firstLevel: [{ userRef: 'shouldBeSame' },
                               { SecondHash: 'SecondHash' }] }

      expect(subject.mm_underscore_keys).to eq(
        first_level: [{ user_ref: 'shouldBeSame' },
                      { second_hash: 'SecondHash' }]
      )
    end
  end

  describe '.keys_to_camel' do
    it 'handles a single element' do
      subject = { user_ref: 'shouldBeSame' }

      expect(subject.mm_camelize_keys).to eq(userRef: 'shouldBeSame')
    end

    it 'handles multiple key/value pairs' do
      subject = { user_ref: 'shouldBeSame', foo_bar: 'fooBar' }

      expect(subject.mm_camelize_keys).to eq(userRef: 'shouldBeSame',
                                             fooBar: 'fooBar')
    end

    it 'handles a nested hash' do
      subject = { user_ref: 'shouldBeSame',
                  nested_foo: { inner_foo: 'shouldBeSame' } }

      expect(subject.mm_camelize_keys).to eq(
        userRef: 'shouldBeSame',
        nestedFoo: { innerFoo: 'shouldBeSame' }
      )
    end

    it 'handles an array of hashes' do
      subject = { first_level: [{ user_ref: 'shouldBeSame' },
                                { second_hash: 'SecondHash' }] }

      expect(subject.mm_camelize_keys).to eq(
        firstLevel: [{ userRef: 'shouldBeSame' },
                     { secondHash: 'SecondHash' }]
      )
    end
  end
end
