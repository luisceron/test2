require 'rails_helper'

feature "users" do
  given!(:user){ create(:user) }

  background :each do
    login create(:user)
    visit users_path
  end

  scenario "listing users" do
    expect(page).to have_content("Usuários")
    expect(page).to have_content("Novo Usuário")
  end

  scenario "creating a new user" do
    visit new_user_path

    fill_in "E-mail", with: "luis@simplefinance.com"
    fill_in "Nome", with: "Luis"
    fill_in "Senha", with: "12345678"
    fill_in "Confirmação de Senha", with: "12345678"
    click_on "Criar Usuário"

    expect(page).to have_content("Usuário criado com sucesso")
    expect(page).to have_content("Luis")
  end
  
  scenario "showing user" do
    visit "/users/#{user.id}"

    expect(page).to have_content(user.name)
    expect(page).to have_content("Editar")
  end

  scenario "updating user" do
    visit "/users/#{user.id}/edit"

    fill_in "Nome", with: "Marco"
    fill_in "Senha", with: "12345678"
    fill_in "Confirmação de Senha", with: "12345678"
    click_on "Atualizar Usuário"

    expect(page).to have_content("Usuário atualizado com sucesso")
    expect(page).to have_content("Marco")
  end

  scenario "removing user" do
    first(:link, "Excluir").click
    expect(page).to have_content("Usuário removido com sucesso")
  end

  scenario "signing out" do
    click_on "Logout"
    expect(page).to have_content("Logout efetuado com sucesso")
  end
end
