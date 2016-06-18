require "rails_helper"

RSpec.describe AccountsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "users/1/accounts").to route_to("accounts#index", user_id: "1")
    end

    it "routes to #new" do
      expect(:get => "users/1/accounts/new").to route_to("accounts#new", user_id: "1")
    end

    it "routes to #show" do
      expect(:get => "/accounts/1").to route_to("accounts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/accounts/1/edit").to route_to("accounts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "users/1/accounts").to route_to("accounts#create", user_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/accounts/1").to route_to("accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/accounts/1").to route_to("accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/accounts/1").to route_to("accounts#destroy", :id => "1")
    end

  end
end
