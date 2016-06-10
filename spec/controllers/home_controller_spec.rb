require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  sign_in_normal_user

  let(:valid_session) {{}}

  describe "GET #index" do
    it "returns http success" do
      get :index, {}, valid_session
      expect(response).to have_http_status(:success)
    end
  end
end
