require 'rails_helper'

RSpec.describe Api::ResourceListsController, type: :controller do
  before do
    authenticate_user(@test_admin_user)
  end

  context 'POST #number_search' do
    before do
      @search_params = { area_code: '775', in_postal_code: '89820', contains: '345' }.to_camelback_keys

      @twilio_results = {
        "available_phone_numbers": [
          {
            "friendly_name": "(775) 204-8394",
            "phone_number": "+17752048394",
            "lata": "720",
            "rate_center": "RENO",
            "latitude": "39.529600",
            "longitude": "-119.813800",
            "locality": "Reno",
            "region": "NV",
            "postal_code": "89501",
            "iso_country": "US",
            "address_requirements": "none",
            "beta": false,
            "capabilities": {
              "voice": true,
              "SMS": true,
              "MMS": true,
              "fax": true
            }
          }, {
            "friendly_name": "(775) 234-0363",
            "phone_number": "+17752340363",
            "lata": "720",
            "rate_center": "BAKER",
            "latitude": "38.906200",
            "longitude": "-114.202200",
            "locality": "Baker",
            "region": "NV",
            "postal_code": "89311",
            "iso_country": "US",
            "address_requirements": "none",
            "beta": false,
            "capabilities": {
              "voice": true,
              "SMS": true,
              "MMS": true,
              "fax": true
            }
          }
        ]
      }
    end

    it 'should find search and find numbers' do
      allow(CommunicationService::PhoneNumberSearch).to receive(:process).and_return(@twilio_results)
      post :number_search, params: { search: @search_params }
      expect(json['numbers']).to_not be_empty
    end
  end
end
