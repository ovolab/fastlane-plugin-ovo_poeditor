require 'fastlane_core/ui/ui'
require 'fastlane'

require 'json'
require 'open-uri'
require 'fileutils'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class OvoPoeditorHelper
      # class methods that you define here become available in your action
      # as `Helper::OvoPoeditorHelper.your_method`
      def self.sync_xcstrings(api_token:, project_id:, language:, output_dir:)
        UI.message("Fetching terms with token: #{api_token}, for project: #{project_id}, ref language: #{language}")

        export_response = Fastlane::Actions.sh(
          "curl -s -X POST https://api.poeditor.com/v2/projects/export "\
          "-d api_token=#{api_token} "\
          "-d id=#{project_id} "\
          "-d language=#{language} "\
          "-d type=xcstrings "\
          "-d options='[{\"export_all\":1}]'"
        )
    
        export_url = JSON.parse(export_response).dig("result", "url")
    
        if export_url.nil?
          UI.user_error!("Failed to get export URL for #{language}")
        end

        # Download the file
        strings_data = URI.open(export_url).read
        output_path = "#{output_dir}/Localizable.xcstrings"
        FileUtils.mkdir_p(output_dir)
        File.write(output_path, strings_data)

        UI.success("Downloaded localization file for #{language} to #{output_path}")
      end

      def self.sync_strings(api_token:, project_id:, languages:, output_dir:)
        UI.message("Fetching terms with token: #{api_token}, for project: #{project_id}, languages: #{languages}")

        languages.each do |language|
          export_response = Fastlane::Actions.sh(
          "curl -s -X POST https://api.poeditor.com/v2/projects/export "\
          "-d api_token=#{api_token} "\
          "-d id=#{project_id} "\
          "-d language=#{language} "\
          "-d type=apple_strings"
          )
    
          export_url = JSON.parse(export_response).dig("result", "url")
    
          if export_url.nil?
            UI.user_error!("Failed to get export URL for #{language}")
          end

          # Download the file
          strings_data = URI.open(export_url).read
          new_output_dir = "#{output_dir}/#{language}.lproj"
          output_path = "#{new_output_dir}/Localizable.strings"
          FileUtils.mkdir_p(new_output_dir)
          File.write(output_path, strings_data)
        end

        UI.success("Downloaded localization files to #{output_dir}")
      end
    end
  end
end
