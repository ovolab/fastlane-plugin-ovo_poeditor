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
      @supported_export_types = ["apple_strings", "xcstrings", "android_strings"].freeze

      def self.sync_strings(api_token:, project_id:, languages:, output_dir:, file_format:, file_name:)
        unless @supported_export_types.include?(file_format)
          UI.user_error!("Invalid export type '#{file_format}'. Allowed values: #{@supported_export_types.join(', ')}")
        end

        languages.each do |language|
          UI.message("Fetching terms for language: #{language}")

          export_url = fetch_export_url(
            api_token: api_token,
            project_id: project_id,
            language: language,
            file_format: file_format
          )

          if export_url.nil?
            UI.error("No export URL for language '#{language}'. Please check if it's enabled in POEditor.")
            next
          end

          strings_data = download_file(export_url, language)
          next unless strings_data

          output_path = build_output_path(output_dir, language, file_name, file_format)

          begin
            FileUtils.mkdir_p(File.dirname(output_path))
            File.write(output_path, strings_data)
            UI.success("Downloaded localization file for #{language} to #{output_path}")
          rescue Errno::EACCES => e
            UI.error("Permission denied while writing to #{output_path}: #{e.message}")
          rescue IOError, SystemCallError => e
            UI.error("Failed to write file for #{language}: #{e.message}")
          end
        end
      end

      def self.fetch_export_url(api_token:, project_id:, language:, file_format:)
        uri = URI("https://api.poeditor.com/v2/projects/export")
        request = Net::HTTP::Post.new(uri)

        form_data = {
          "api_token" => api_token,
          "id" => project_id,
          "language" => language,
          "order" => "terms",
          "type" => file_format
        }
        form_data["options"] = '[{"export_all":1}]' if file_format == "xcstrings"

        request.set_form_data(form_data)

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        return nil unless response.is_a?(Net::HTTPSuccess)

        result = JSON.parse(response.body)
        result.dig("result", "url")
      rescue JSON::ParserError => e
        UI.error("Failed to parse POEditor response: #{e.message}")
        nil
      end

      def self.download_file(url, language)
        URI.open(url).read
      rescue => e
        UI.error("Error downloading file for language '#{language}': #{e.message}")
        nil
      end

      def self.build_output_path(base_dir, language, file_name, format)
        if format == "xcstrings"
          "#{base_dir}/#{file_name}"
        else
          "#{base_dir}/#{language}/#{file_name}"
        end
      end
    end
  end
end
