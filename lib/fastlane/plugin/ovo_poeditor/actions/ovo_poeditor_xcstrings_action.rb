require 'fastlane/action'
require_relative '../helper/ovo_poeditor_helper'

module Fastlane
  module Actions
    class OvoPoeditorXcstringsAction < Action
      def self.run(params)
        api_token = params[:api_token]
        project_id = params[:project_id]
        language = params[:ref_language]
        output_dir = params[:output_dir]

        Helper::OvoPoeditorHelper.sync_xcstrings(
          api_token: api_token,
          project_id: project_id,
          language: language,
          output_dir: output_dir
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
            key: :ref_language,
            env_name: "POEDITOR_XCSTRINGS_LANGUAGE",
            description: "The reference language for the project",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :output_dir,
            env_name: "POEDITOR_XCSTRINGS_OUTPUT_DIR",
            description: "Directory containing xcstrings file",
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
