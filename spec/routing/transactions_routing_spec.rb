require "rails_helper"

RSpec.describe TransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "users/1/transactions").to route_to("transactions#index", user_id: "1")
    end

    it "routes to #new" do
      expect(:get => "users/1/transactions/new").to route_to("transactions#new", user_id: "1")
    end

    it "routes to #show" do
      expect(:get => "/transactions/1").to route_to("transactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/transactions/1/edit").to route_to("transactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "users/1/transactions").to route_to("transactions#create", user_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/transactions/1").to route_to("transactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/transactions/1").to route_to("transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transactions/1").to route_to("transactions#destroy", :id => "1")
    end

  end
end
