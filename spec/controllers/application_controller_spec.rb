require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "After sigin-in" do
    sign_in_admin_user

    it "redirects to the /jobs page" do
      result = controller.after_sign_in_path_for(controller.current_user)
      expect(result).to be_empty
    end
  end
end
