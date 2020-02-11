require 'rails_helper'

include RailsJwtAuth::SpecHelpers

RSpec.describe RailsJwtAuth::ProfilesController do
  %w[ActiveRecord Mongoid].each do |orm|
    context "Using #{orm}" do
      before :all do
        RailsJwtAuth.model_name = "#{orm}User"
      end

      let(:json) { JSON.parse(response.body).first[1] }
      let(:user) { FactoryBot.create("#{orm.underscore}_user") }

      describe 'GET #show' do
        context 'when user is logged' do
          before do
            sign_in user
          end

          it 'returns user info' do
            get :show
            expect(response).to have_http_status(200)
            expect(json['email']).to eq user.email
          end
        end

        context 'when user is not logged' do
          it 'raises RailsJwtAuth::NotAuthorized exception' do
            expect { get :show }.to raise_error RailsJwtAuth::NotAuthorized
          end
        end
      end
    end
  end
end
