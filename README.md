# CreditCardInfo

The Issuer Identification Number (IIN), previously known as Bank Identification Number (BIN) is the first six numbers of a credit card. 
These identify the institution that issued the card to the card holder and 
provide useful information about the card that can help make your payments flow smarter.

Uses 3 data providers:
    * First binlist.net API.
    * Second bincodes.com API (require registration and api key).
    * Third 'credit_card_bins' gem data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'credit_card_info'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install credit_card_info


## Configuration

```ruby
CreditCardInfo::Config.configure do |config|
    # Provider request order
    config.data_providers = %w[Binlist Bincodes CreditCardBins]

    config.bincodes.api_key = "your_api_key"
    config.bincodes.api_url = "https://api.bincodes.com"
    
    # class for make HttpRequests
    config.bincodes.http_klass = Net::HTTP
    # set timeout for api request (10 by default)
    config.bincodes.timeout = 10

    config.binlist.api_url = "https://lookup.binlist.net/"
    # class for make HttpRequests
    config.bincodes.http_klass = Net::HTTP
    # set binlist for api request (10 by default)
    config.bincobinlistdes.timeout = 10
    
    # set cache provider class, Rails.cache by default when using in Rails application
    config.cache.provider = Rails.cache
    # set cache keys lifeitime, default is 31 day
    config.cache.ttl = 2678400
    # set cache keys prefix, result key will be prefix:bin
    config.cache.key_prefix = "ccinfo"
    
    # also you can use custom logger instance, default is Rails.logger for Rails apps, and stdout for others
    config.logger = Logger.new($stdout)
end
```

## Usage

You just need make call:

```ruby
bin = '515735'
CreditCardInfo.fetch(bin)
# { 
#   bin: "515735", 
#   bank: "CITIBANK, N.A.", 
#   card: "MASTERCARD", 
#   type: "CREDIT", 
#   level: "WORLD CARD", 
#   country: "United States", 
#   countrycode: "US"
# }
```

By default that call will be search firstly via binlist.net, and if find nothing will search via bincodes.com,
and if find nothing will search via `credit_card_bins` gem. You can change requests order, by `data_providers` section.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
