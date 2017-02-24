require "tidy_i18n/translation_keys"

describe TidyI18n::TranslationKeys do

  it "has no keys for an empty yaml" do
    TidyI18n::TranslationKeys.parse("").should == []
  end

  it "has one key for just the locale" do
    yaml = <<YAML
en:
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 1
    keys.first.name.should == "en"
    keys.first.value.should == ""
  end

  it "has one nested key" do
    yaml = <<YAML
en:
  foo: "Bar"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 1
    keys.first.name.should == "en.foo"
    keys.first.value.should == "Bar"
  end

  it "has two keys at the same level" do
    yaml = <<YAML
en:
  foo: "FOO"
  bar: "BAR"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 2
    keys.first.name.should == "en.foo"
    keys.first.value.should == "FOO"
    keys.last.name.should == "en.bar"
    keys.last.value.should == "BAR"
  end

  it "has one key nested mutliple times" do
    yaml = <<YAML
en:
  foo:
    bar:
      baz: "123"
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 1
    keys.first.name.should == "en.foo.bar.baz"
    keys.first.value.should == "123"
  end

  it "has keys for a complicated example" do
    yaml = <<YAML
en:
  foo:
    bar: 123
    baz: 456
    quo:
      wat: What
  foo2: Wat
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 4
    keys.map(&:name).should =~ [
      "en.foo.bar",
      "en.foo.baz",
      "en.foo.quo.wat",
      "en.foo2"
    ]
  end

  it "includes a key twice" do
    yaml = <<YAML
en:
  foo: Foo1
  foo: Foo2
YAML
    keys = TidyI18n::TranslationKeys.parse(yaml)
    keys.size.should == 2
    keys.map(&:name).should == ["en.foo", "en.foo"]
    keys.map(&:value).should =~ ["Foo1", "Foo2"]
  end

  describe "Parsing sequences" do
    it "parses the only sequence when it has one element" do
      yaml = <<YAML
en:
  day_names:
    - Monday
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      keys.size.should == 1
      keys.first.name.should == "en.day_names"
      keys.first.value.should == ["Monday"]
    end

    it "has a sequence followed by another key" do
      yaml = <<YAML
en:
  day_names:
    - Monday
  foo: "Bar"
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      keys.size.should == 2
      keys.first.name.should == "en.day_names"
      keys.first.value.should == ["Monday"]
      keys.last.name.should == "en.foo"
      keys.last.value.should == "Bar"
    end

    it "has a two elements sequence" do
      yaml = <<YAML
en:
  day_names:
    - Monday
    - Tuesday
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      keys.size.should == 1
      keys.first.name.should == "en.day_names"
      keys.first.value.should == ["Monday", "Tuesday"]
    end

    xit "has a two elements sequence followed by another key" do
      yaml = <<YAML
en:
  day_names:
    - Monday
    - Tuesday
  foo: "Bar"
YAML

      keys = TidyI18n::TranslationKeys.parse(yaml)

      keys.size.should == 2
      keys.first.name.should == "en.day_names"
      keys.first.value.should == ["Monday", "Tuesday"]
      keys.last.name.should == "en.foo"
      keys.last.value.should == "Bar"
    end
  end
end
