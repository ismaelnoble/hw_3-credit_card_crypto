require_relative './luhn_validator.rb'
require_relative './sk_cipher.rb'
require 'json'
require 'base64'
require 'rbnacl/libsodium'
# this is the cc class
class CreditCard
  # TODO: mixin the LuhnValidator using an 'include' statement
  include LuhnValidator
  # instance variables with automatic getter/setter methods
  attr_accessor :number, :expiration_date, :owner, :credit_network
  attr_accessor :hash_attr

  def initialize(number, expiration_date, owner, credit_network)
    # TODO: initialize the instance variables listed above
    @number = number
    @expiration_date = expiration_date
    @owner = owner
    @credit_network = credit_network
  end

  def to_json
    {
      # TODO: setup the hash with all instance vairables to serialize into json
      :number => @number, :expiration_date => @expiration_date,
      :owner => @owner, :credit_network => @credit_network
    }.to_json
  end

  # returns all card information as single string
  def to_s
    to_json
  end

  # return a new CreditCard object given a serialized (JSON) representation
  def self.from_s(card_s)
    Base64.decode64(card_s)
  end

  # return a hash of the serialized credit card object
  def hash
    Base64.encode64(to_s).hash
  end

  # return a cryptographically secure hash
  def hash_secure
    RbNaCl::Hash.sha256(Base64.encode64(to_s))
  end
end
