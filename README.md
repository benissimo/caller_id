# CallerId

A ruby wrapper around OpenCNAM api. Lookup U.S. cell phone caller ID.

## Installation

Add this line to your application's Gemfile:

    gem 'caller_id'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install caller_id

## Usage

    c = CallerId::ReversePhoneLookup "+1 (202) 456-1414", open_cnam_username, open_cnam_api_key # Username and key are optional. Sign up at opencnam.com to get them.
    c.lookup # {:cnam => "WHITE HOUSE SWI", :number => "2024561414"}

Note: if a number has not yet been mapped by OpenCNAM, you'll get a response containing :retry => true (see the spec).

In that case you should wait a few seconds and then try the call again. You may want to do this in a background queue.

Also note, 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
