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

        Helper::OvoPoeditorHelper.sync_strings(
          api_token: api_token,
          project_id: project_id,
          languages: languages,
          output_dir: output_dir,
          file_format: file_format,
          file_name: file_name
        )
      end

      def self.description
        "Fetch latest POEditor terms and download them as .xcstrings file"
      end

      def self.authors
        ["Alessio Arsuffi"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "Return an xcstrings file with all POEditor terms"
      end

      def self.details
        # Optional:
        "Fetch latest POEditor terms and download them as .xcstrings file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_token,
            env_name: "POEDITOR_API_TOKEN",
            description: "POEditor read-only API Token",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_id,
            env_name: "POEDITOR_PROJECT_ID",
            description: "POEditor Project ID",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :languages,
            env_name: "POEDITOR_LANGUAGES",
            description: "The languages to export strings for",
            optional: false,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_dir,
            env_name: "POEDITOR_OUTPUT_DIR",
            description: "Directory containing xcstrings file",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_name,
            env_name: "POEDITOR_FILE_NAME",
            description: "The name of the file to be downloaded",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_format,
            env_name: "POEDITOR_EXPORT_FILE_FORMAT",
            description: "Export file format (xcstrings, apple_strings, android_strings)",
            optional: false,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
