# Guard::Git

Stops [Guard](https://github.com/guard/guard/) triggering plugins whenever
you change branches.

## Installation

**NOTE:** This has not yet been released, so cannot be installed without
cloning this repo.

~Add this line to your application's Gemfile:~

```ruby
gem 'guard-git'
```

~And then execute:~

    $ bundle

~Or install it yourself as:~

    $ gem install guard-git

## Usage

There are two ways to use this gem:

### Make all `watch` calls git aware

This is the simplest way to get started and the default way to use this gem.

Add the following to the top of your `Guardfile`:

```ruby
require `guard/git`

Guard::Git.enable!
```

All of the calls to `watch` will now only be triggered if the file changes on
disk and one of the follwing is true:

- The file has changed since `HEAD`
- The file is untracked
- The file is gitignored

### Explicitly use the git matcher

If you only want to use git-aware matchers for a subset of `watch` calls or
you'd prefer not to monkeypatch Guard, you can use the
`Guard::Git::ChangedFilesMatcher` instead.

For example, if you had the follwing `Guardfile`:

```ruby
guard :shell do
  watch(/.*/) do
    # do something
  end
end
```

you can make that single `watch` git-aware by changing the file to:

```ruby
require `guard/git`

guard :shell do
  watch(Guard::Git::ChangedFilesMatcher.new(/.*/)) do
    # do something
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you
to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Testing

To properly end-to-end test this gem it's necessary to have a process running
`guard` to verify which file changes cause plugins to be triggered. `guard`
needs to run in a tty rather than a background process. Therefore, before
running any specs, run `bin/setup_integration_test` in a terminal to create a
test guard process.

Once you have the test `guard` process set up, run `bundle exec rake spec`
to run all the tests once, or `bin/guard` to start a guard process that will
run relevant tests and linting on any file change.

You may need to restart `bin/setup_integration_test` between some test runs
during development as the test `guard` process only loads the gem at the start
rather than before each test (it `require`s the files in
[the `Guardfile`](test_project/Guardfile)).

### Releasing new versions

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/dp28/guard-git.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
