# nokogiri_schematron_builder

Build [Schematron](http://schematron.com) XML documents using [Nokogiri](https://nokogiri.org).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nokogiri_schematron_builder"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nokogiri_schematron_builder

## Usage

Add this line to your application:

```ruby
require "nokogiri/xml/schematron/schema"
```

Create the schema using the domain-specific language:

```ruby
schema = Nokogiri::XML::Schematron::Schema.new(title: "Example schema") do
  ns(prefix: "ex", uri: "http://example.com/ns#")
  pattern(name: "Example pattern") do
    rule(context: "/") do
      assert(test: "count(ex:A) &gt;= 1", message: "element \"ex:A\" is REQUIRED")
    end
    rule(context: "/ex:A") do
      assert(test: "count(ex:B) &gt;= 0", message: "element \"ex:B\" is OPTIONAL")
    end
    rule(context: "/ex:A/ex:B") do
      assert(test: "not(ex:C)", message: "element \"ex:C\" is NOT RECOMMENDED")
    end
  end
end
```

Or, equivalently:

```ruby
schema = Nokogiri::XML::Schematron::Schema.new(title: "Example schema") do
  ns(prefix: "ex", uri: "http://example.com/ns#")
  pattern(name: "Example pattern") do
    context("/") do
      require("ex:A") do
        permit("ex:B") do
          reject("ex:C")
        end
      end
    end
  end
end
```

Next, construct a [`Nokogiri::XML::Builder`](https://nokogiri.org/rdoc/Nokogiri/XML/Builder.html) object:

```ruby
builder = schema.to_builder(encoding: "UTF-8")
```

Finally, generate the XML:

```ruby
xml = builder.to_xml
```

The result is:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" title="Example schema">
  <sch:ns prefix="ex" uri="http://example.com/ns#"/>
  <sch:pattern name="Example pattern">
    <sch:rule context="/">
      <sch:assert test="count(ex:A) &gt;= 1">element "ex:A" is REQUIRED</sch:assert>
    </sch:rule>
    <sch:rule context="/ex:A">
      <sch:assert test="count(ex:B) &gt;= 0">element "ex:B" is OPTIONAL</sch:assert>
    </sch:rule>
    <sch:rule context="/ex:A/ex:B">
      <sch:assert test="not(ex:C)">element "ex:C" is NOT RECOMMENDED</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

[The 2-Clause BSD License](https://opensource.org/licenses/BSD-2-Clause)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pnnl/nokogiri_schematron_builder.
