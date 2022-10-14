# Tidy I18n

[![Build Status](https://travis-ci.org/ericmeyer/tidy_i18n.svg?branch=master)](https://travis-ci.org/ericmeyer/tidy_i18n)
[![Gem Version](https://badge.fury.io/rb/tidy_i18n.svg)](https://badge.fury.io/rb/tidy_i18n)

TidyI18n is a gem that wraps the I18n gem. It's purpose is to help you manage your locale files. Features include:

 * Searching locale files for duplicate keys
 * Finding missing keys in a given locale

NOTE: This gem uses a nonstandard yaml structure for the translation strings. Instead of e.g. `en.foo.create.success` it uses
the project route: `en.app.controllers.foo.create.success`.

## Dependencies

 * Ruby
    * .ruby-version file contains the latest version confirmed supported
    * See .travis.yml for more supported versions
 * Bundler

## Usage

Install the gem.

`gem install tidy_i18n`

OR

Add `gem "tidy_i18n"` to your Gemfile.

Configure your project root:
`TidyI18n.project_root="/absolute/path/to/project"`

Configure I18n gem.

## Setup

1. Clone repo
1. `gem install bundler`
1. `bundle install`

### Running Tests

`rake spec`
