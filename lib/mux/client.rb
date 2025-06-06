# frozen_string_literal: true

require "mux_ruby"

module Mux
  class Client
    class << self
      def create_asset(url, options = {})
        playback_policy = options.fetch(:playback_policy, "public")
        request = MuxRuby::CreateAssetRequest.new
        request.input = url
        request.playback_policy = MuxRuby::PlaybackPolicy.build_from_hash(playback_policy)

        allowed_attributes = %i[passthrough mp4_support normalize_audio per_title_encode test
                        max_resolution_tier encoding_tier master_access inputs
                        playback_policies advanced_playback_policies video_quality
                        static_renditions meta]

        # Apply only whitelisted options
        options.each do |key, value|
          if allowed_attributes.include?(key)
            request.public_send("#{key}=", value)
          end
        end

        response = assets_api.create_asset(request)
        response.data.id
      end

      def destroy_asset(asset_id, options = {})
        assets_api.delete_asset(asset_id, options)
      end

      # TODO: Figure out if and how to wrap the response
      def get_asset(asset_id, options = {})
        assets_api.get_asset(asset_id, options)
      end

      private
        def assets_api
          @assets_api ||= MuxRuby::AssetsApi.new
        end
    end
  end
end
