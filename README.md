# What is multilang

Support multilingualization.

## Installation

Add this line to your application's Gemfile:

    gem 'multilang'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multilang

## Usage

You will support multilingualization to following:

    require 'multilang'

    module Tokenizer
      class English

        # register Tokenizer::English to Tokenizer as English
        Multilang.register self

      end

      class Japanese

        # Class.#include is okay
        include Multilang

      end
    end

You can use the multilingualized module to following:

    english_tokenizer = Tokenizer[:en].new
    japanese_tokenizer = Tokenizer['Japanese'].new

### Register regardless name of class

By specifying `:as` option, you can register regardless name of class:

    module Tokenizer
      class E
        Multilang.register self, :as => 'English'
      end

      class J

        # ISO639-2 or ISO639-1 is okay
        # (http://www.loc.gov/standards/iso639-2/php/code_list.php)
        Multilang.register self, :as => :ja

      end
    end

### Process at getting the class (or module) first

By giving a block to the `Multilang.#register`, you can execute code arbitrarily
at getting an object first from a multilingualized module:

    module Tokenizer
      class English
        Multilang.register self do
          # execute once at getting first
        end
      end
    end

By specifying `:with` option, you can call `Kernel.#require`:

    module Tokenizer
      class English
        Multilang.register self, :with => 'tokenizer/en'
      end
    end

Of course you can specify both a block and `:with` option.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
