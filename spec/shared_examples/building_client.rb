RSpec.shared_examples 'building the Api.ai client' do
  context 'building the ApiAiRuby::Client' do
    let(:token) { 'sometoken' }

    context 'when client credentials are set via environment variables' do
      it 'sets the developer access token based on environment variables, if available' do
        env_vars = {
            API_AI_DEVELOPER_ACCESS_TOKEN: token,
            API_AI_CLIENT_ACCESS_TOKEN:    nil
        }
        credentials = {
            developer_access_token: token,
            client_access_token:    nil
        }

        ClimateControl.modify( env_vars ) do
          subject
          expect( ApiAiRuby::Client ).to have_received( :new ).with( credentials )
        end
      end

      it 'sets the client access token based on environment variables, if available' do
        env_vars = {
            API_AI_DEVELOPER_ACCESS_TOKEN: nil,
            API_AI_CLIENT_ACCESS_TOKEN:    token
        }
        credentials = {
            developer_access_token: nil,
            client_access_token:    token
        }

        ClimateControl.modify( env_vars ) do
          subject
          expect( ApiAiRuby::Client ).to have_received( :new ).with( credentials )
        end
      end
    end

    context 'when client credentials are passed directly' do
      let( :nil_env_vars ) {
        {
            API_AI_DEVELOPER_ACCESS_TOKEN: nil,
            API_AI_CLIENT_ACCESS_TOKEN:    nil
        }
      }

      it 'sets the developer access token based on passed arguments' do
        credentials = {
            developer_access_token: token,
            client_access_token: nil
        }

        ClimateControl.modify( nil_env_vars ) do
          Expando::EntityUpdater.new( :appliances, client_keys: { developer_access_token: token } )
          expect( ApiAiRuby::Client ).to have_received( :new ).with( credentials )
        end
      end

      it 'sets the client access token based on passed arguments' do
        credentials = {
            developer_access_token: nil,
            client_access_token: token
        }

        ClimateControl.modify( nil_env_vars ) do
          Expando::EntityUpdater.new( :appliances, client_keys: { client_access_token: token } )
          expect( ApiAiRuby::Client ).to have_received( :new ).with( credentials )
        end
      end
    end
  end
end
