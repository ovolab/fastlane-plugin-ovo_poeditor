require 'fastlane/action'
require_relative '../helper/ovo_poeditor_helper'

module Fastlane
  module Actions
    class OvoPoeditorStringsAction < Action
      def self.run(params)
        api_token = params[:api_token]
        project_id = params[:project_id]
        languages = params[:languages]
        output_dir = params[:output_dir]
        file_format = params[:file_format]
        file_name = params[:file_name]
        default_language = params[:default_language]
        language_map = params[:language_map]
        unquoted_strings = params[:unquoted_strings]
        bypass_default_language = params[:bypass_default_language]

        Helper::OvoPoeditorHelper.sync_strings(
          api_token: api_token,
          project_id: project_id,
          languages: languages,
          output_dir: output_dir,
          file_format: file_format,
          file_name: file_name,
          default_language: default_language,
          language_map: language_map,
          unquoted_strings: unquoted_strings,
          bypass_default_language: bypass_default_language
        )
      end

      def self.description
        'Fetch latest POEditor terms and download them as .strings/.xml/.xcstrings file'
      end

      def self.authors
        ['Alessio Arsuffi', 'Christian Borsato']
      end

      def self.return_value
        'Return a file with all POEditor terms'
      end

      def self.details
        'Fetch latest POEditor terms and download them as .strings/.xml/.xcstrings file'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_token,
            env_name: 'POEDITOR_API_TOKEN',
            description: 'POEditor API token (read-only recommended)',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_id,
            env_name: 'POEDITOR_PROJECT_ID',
            description: 'POEditor project ID',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :languages,
            env_name: 'POEDITOR_LANGUAGES',
            description: 'List of language codes to export (e.g. ["en", "it"])',
            optional: false,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_dir,
            env_name: 'POEDITOR_OUTPUT_DIR',
            description: 'Output directory where the localized files will be written',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_name,
            env_name: 'POEDITOR_FILE_NAME',
            description: 'Output file name to write (e.g. Localizable.strings, strings.xml)',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_format,
            env_name: 'POEDITOR_EXPORT_FILE_FORMAT',
            description: 'Export file format: xcstrings, apple_strings, android_strings',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :default_language,
            env_name: 'POEDITOR_DEFAULT_LANGUAGE',
            description: 'Optional. Default/fallback language code for the project',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :language_map,
            description: 'Optional. Map POEditor language codes to platform-specific folder names',
            optional: true,
            type: Hash
          ),
          FastlaneCore::ConfigItem.new(
            key: :unquoted_strings,
            env_name: 'POEDITOR_UNQUOTED_STRINGS',
            description: 'Optional. Set to 1 to export Android strings without quotes (unquoted). Allowed values: 0 or 1',
            optional: true,
            type: Integer,
            default_value: 0,
            verify_block: proc do |value|
              UI.user_error!("unquoted_strings (POEDITOR_UNQUOTED_STRINGS) must be 0 or 1. Received: #{value}.") unless [0, 1].include?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :bypass_default_language,
            env_name: 'POEDITOR_BYPASS_DEFAULT_LANGUAGE',
            description: 'Optional. Skip the default language check when the output path is built',
            optional: true,
            type: Boolean,
            default_value: false
          )
        ]
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
