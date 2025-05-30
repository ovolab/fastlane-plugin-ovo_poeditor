# Ovo POEditor Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-ovo_poeditor)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ovo_poeditor`, add it to your project by running:

```bash
fastlane add_plugin ovo_poeditor
```

## About Ovo POEditor

Fetch latest POEditor terms and download them as `.xcstrings/.strings/.xml` file

## Available Actions

### ovo_poeditor_strings

This action will download the latest terms from POEditor to the specified `output_dir` in the specified `file_format`.

#### iOS

##### `xcstrings`:
```ruby
ovo_poeditor_strings(
  api_token: "api_token",
  project_id: "project_id",
  languages: ["fr"], 
  output_dir: "./XCStrings",
  file_format: "xcstrings",
  file_name: "Localizable.xcstrings"
)
```
NB: when `file_format: "xcstrings"`, you can pass a single language to the script, it will export all the available languages in the project to the `.xcstrings` file.

##### `strings`:
```ruby
ovo_poeditor_strings(
  api_token: "api_token",
  project_id: "project_id",
  languages: ["fr", "en", "it", "ru"], 
  output_dir: "./Strings",
  file_format: "apple_strings",
  file_name: "Localizable.strings"
)
```

#### Android
```ruby
ovo_poeditor_strings(
  api_token: "api_token",
  project_id: "project_id",
  languages: ["fr", "en", "it", "ru"], 
  output_dir: "./values",
  file_format: "android_strings",
  file_name: "strings.xml"
)
```


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
