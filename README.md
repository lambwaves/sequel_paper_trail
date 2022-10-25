Sequel plugin for Paper Trail
=============

This is a simple Sequel plugin for PaperTrail (with limited functionality).

Contributions are welcome!

[![Travis badge](https://github.com/lambwaves/sequel_paper_trail/actions/workflows/ruby.yml/badge.svg)](https://github.com/lambwaves/sequel_paper_trail/actions/workflows/ruby.yml)
[![Coverage Status](https://coveralls.io/repos/github/lambwaves/sequel_paper_trail/badge.svg)](https://coveralls.io/github/lambwaves/sequel_paper_trail)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)

Features
------------

* Track when models are created, updated, or deleted
* specify current_user as whodunnit
* can be specified info_for_paper_trail
* versioning can be disabled or enabled globally or in a block context

Limitations
------------

* this gem doesn't create a version table
* this is forked from 7 year old code, and I may not accept PRs.
* info_for_paper_trail is global
* does not reify

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'sequel_paper_trail', github: 'lambwaves/sequel_paper_trail'
```

Documentation
-------------


Usage
-------------

Quick start:

```ruby

require 'sequel_paper_trail'
require 'sequel'
require 'sequel/plugins/has_paper_trail'

Album.plugin :has_paper_trail, class_name: 'VersionClassName'

class AlbumsController < BaseController
  before_action :set_user_for_papertrail

  def set_user_for_papertrail
    SequelPaperTrail.whodunnit = current_user.id
  end
end
```

Enable versioning globally:

```ruby

SequelPaperTrail.enabled = true

```

Enable versioning for a block of code:

```ruby

SequelPaperTrail.with_versioning { 'code' }

```

Disable versioning globally:

```ruby

SequelPaperTrail.enabled = false

```

Disable versioning for a block of code

```ruby

SequelPaperTrail.with_versioning(false) { 'code' }

```

Set whodunnit:

```ruby

SequelPaperTrail.whodunnit = 'Mr. Smith'

```

Set info_for_paper_trail - additional info (Hash) which will be attached to the versions table.

```ruby
# If you have 'release' and 'instance' columns in a versions table you can populate them.

SequelPaperTrail.info_for_paper_trail = { release: 'asdf131234', instance: `hostname` }

```

Development
--------------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

I specify the location of this gem in my application's Gemfile.


Contributing
--------------

I have minimal functionality, so contributions might not be received applicably. 

Bug reports and pull requests are welcome on GitHub at https://github.com/lazebny/sequel_paper_trail.


License
--------------

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

