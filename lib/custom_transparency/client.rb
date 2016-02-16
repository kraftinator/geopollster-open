module CustomTransparency
  class Client < MonsterMash::Base
    
    defaults do
      params :apikey => CustomTransparency.api_key
    end
    
    get(:contributions) do |api_params|
      uri CustomTransparency.api_url("/contributions")
      params CustomTransparency::Client.prepare_params(api_params)
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end
    
    get(:lobbying) do |api_params|
      uri CustomTransparency.api_url("/lobbying")
      params CustomTransparency::Client.prepare_params(api_params)
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end
    
    get(:entities) do |api_params|
      uri CustomTransparency.api_url("/entities")
      params CustomTransparency::Client.prepare_params(api_params)
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end
    
    get(:id_lookup) do |api_params|
      uri CustomTransparency.api_url("/entities/id_lookup")
      params CustomTransparency::Client.prepare_params(api_params)
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end
    
    get(:entity) do |id, api_params|
      uri CustomTransparency.api_url("/entities/#{id}")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        Hashie::Mash.new(JSON.parse(response.body))
      end
    end
    
    get(:top_contributors) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/pol/#{id}/contributors")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end

    get(:top_sectors) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/pol/#{id}/contributors/sectors")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        sectors = CustomTransparency::Client.handle_response(response)
        CustomTransparency::Client.process_sectors(sectors)
      end
    end

    get(:top_industries) do |id, sector, api_params|
      uri CustomTransparency.api_url("/aggregates/pol/#{id}/contributors/sector/#{sector}/industries")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end


    get(:local_breakdown) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/pol/#{id}/contributors/local_breakdown")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        CustomTransparency::Client.process_local_breakdown(breakdown)
      end
    end

    get(:contributor_type_breakdown) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/pol/#{id}/contributors/type_breakdown")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        CustomTransparency::Client.process_contributor_type_breakdown(breakdown)
      end
    end

    get(:top_recipient_orgs) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/indiv/#{id}/recipient_orgs")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end

    get(:top_recipient_pols) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/indiv/#{id}/recipient_pols")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end

    get(:individual_party_breakdown) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/indiv/#{id}/recipients/party_breakdown")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        CustomTransparency::Client.process_party_breakdown(breakdown)
      end
    end

    get(:top_org_recipients) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/org/#{id}/recipients")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        CustomTransparency::Client.handle_response(response)
      end
    end

    get(:org_party_breakdown) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/org/#{id}/recipients/party_breakdown")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        CustomTransparency::Client.process_org_party_breakdown(breakdown)
      end
    end

    get(:org_level_breakdown) do |id, api_params|
      uri CustomTransparency.api_url("/aggregates/org/#{id}/recipients/level_breakdown")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        breakdown = Hashie::Mash.new(JSON.parse(response.body))
        CustomTransparency::Client.process_org_level_breakdown(breakdown)
      end
    end

    get(:recipient_contributor_summary) do |recipient_id, contributor_id, api_params|
      uri CustomTransparency.api_url("/aggregates/recipient/#{recipient_id}/contributor/#{contributor_id}/amount")
      params CustomTransparency::Client.prepare_params(api_params) if api_params
      handler do |response|
        Hashie::Mash.new(JSON.parse(response.body))
      end
    end

    def self.prepare_params(params)
      params.each do |key, value|
        if value.is_a?(Hash)
          
          case value.keys.first
          when :gte
            params[key] = ">|#{value.values.first}"
          when :lte
            params[key] = "<|#{value.values.first}"
          when :between
            params[key] = "><|#{value.values.first.join('|')}"
          end
          
        elsif value.is_a?(Array)
          params[key] = value.join("|")
        
        elsif value.is_a?(String)
          params[key] = value.sub(/[\*\?!=&%]/,'')
        end
      end
      params
    end
    
    def self.handle_response(response)
      # TODO: raise_errors
      JSON.parse(response.body).map {|c| Hashie::Mash.new(c)}
    end
    
    def self.process_sectors(sectors)
      sectors.each do |sector|
        sector["name"] = case sector.sector
          when "A" then "Agribusiness"
          when "B" then "Communications/Electronics"
          when "C" then "Construction"
          when "D" then "Defense"
          when "E" then "Energy/Natural Resources"
          when "F" then "Finance/Insurance/Real Estate"
          when "H" then "Health"
          when "K" then "Lawyers/Lobbyists"
          when "M" then "Transportation"
          when "N" then "Misc. Business"
          when "Q" then "Ideology/Single Issue"
          when "P" then "Labor"
          when "W" then "Other"
          when "Y" then "Unknown"
          when "Z" then "Administrative Use"
        end
      end
    end
    
    def self.process_local_breakdown(breakdown)
      CustomTransparency::Client.mashize_key(breakdown, "in-state", "in_state")
      CustomTransparency::Client.mashize_key(breakdown, "out-of-state", "out_of_state")
      breakdown
    end
    
    def self.process_contributor_type_breakdown(breakdown)
      CustomTransparency::Client.mashize_key(breakdown, "Individuals", "individual")
      CustomTransparency::Client.mashize_key(breakdown, "PACs", "pac")
      breakdown
    end
    
    def self.process_party_breakdown(breakdown)
      CustomTransparency::Client.mashize_key(breakdown, "Democrats", "dem")
      CustomTransparency::Client.mashize_key(breakdown, "Republicans", "rep")
      CustomTransparency::Client.mashize_key(breakdown, "L", "lib")
      CustomTransparency::Client.mashize_key(breakdown, "I", "ind")
      CustomTransparency::Client.mashize_key(breakdown, "U", "unknown")
      CustomTransparency::Client.mashize_key(breakdown, "Other", "other")
      CustomTransparency::Client.mashize_key(breakdown, "3", "third")
      breakdown
    end

    def self.process_org_party_breakdown(breakdown)
      CustomTransparency::Client.mashize_key(breakdown, "Democrats", "dem")
      CustomTransparency::Client.mashize_key(breakdown, "Republicans", "rep")
      CustomTransparency::Client.mashize_key(breakdown, "L", "lib")
      CustomTransparency::Client.mashize_key(breakdown, "I", "ind")
      CustomTransparency::Client.mashize_key(breakdown, "U", "unknown")
      CustomTransparency::Client.mashize_key(breakdown, "Other", "other")
      CustomTransparency::Client.mashize_key(breakdown, "3", "third")
      breakdown
    end
    
    def self.process_org_level_breakdown(breakdown)
      CustomTransparency::Client.mashize_key(breakdown, "State", "state")
      CustomTransparency::Client.mashize_key(breakdown, "Federal", "federal")
      breakdown
    end
    
    def self.mashize_key(breakdown, api_key, mash_key)
      if breakdown[api_key]
        breakdown["#{mash_key}_count"]  = breakdown[api_key][0].to_i
        breakdown["#{mash_key}_amount"] = breakdown[api_key][1].to_f
      end
    end

  end
end