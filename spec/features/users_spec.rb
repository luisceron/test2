require 'rails_helper'

feature "users" do
  before :each do
    login create(:user)
  end

  let(:user){ create(:user) }

  scenario "listing users" do
    visit users_path

    expect(page).to have_content("Usuários")
    expect(page).to have_content("Novo Usuário")
  end
  
end