require 'rails_helper'

RSpec.describe "Api::V1::Timeline", type: :request do
  context 'Unauthenticated' do
    it_behaves_like :deny_without_authorization, :get, '/api/v1/timeline'
  end

  context 'Authenticated' do
    let(:user) { create(:user) }
    let(:tweets_number) { Random.rand(1..5) }
    let(:follower) { create(:user) }
    
    before { user.follow(follower) }
    before { create(:tweet, user: follower) }
    
    before { tweets_number.times { create(:tweet, user: user) } }
    before { get '/api/v1/timeline', headers: header_with_authentication(user) }

    it { expect(response).to have_http_status(:success) }
    it { expect(json).to include_json(each_serialized(Api::V1::TweetSerializer, (follower.tweets + user.tweets).reverse)) }
  end
end