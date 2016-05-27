require 'rails_helper'

feature "users for admin user" do
  given!(:user){ create(:user) }

  background :each do
    login create(:user, admin: true)
    visit users_path
  end

  scenario "listing users" do
    expect(page).to have_content("Lista de Usuários")
  end

  scenario "creating a new user" do
    visit new_user_path

    fill_in "E-mail", with: "luis@simplefinance.com"
    fill_in "Nome", with: "Luis"
    click_on "Salvar"

    expect(page).to have_content("Usuário criado com sucesso")
    expect(page).to have_content("luis")
  end
  
  scenario "showing user" do
    visit "/users/#{user.id}"

    expect(page).to have_content(user.name)
    expect(page).to have_content("Editar")
  end

  scenario "updating user" do
    visit "/users/#{user.id}/edit"

    fill_in "Nome", with: "Marco"
    click_on "Salvar"

    expect(page).to have_content("Usuário atualizado com sucesso")
    expect(page).to have_content("Marco")
  end

  scenario "removing user" do
    first('.btn-danger').click
    expect(page).to have_content("Usuário removido com sucesso")
  end

  scenario "signing out" do
    click_on "Logout"
    expect(page).to have_content("Logout efetuado com sucesso")
  end
end

feature "users for normal user" do
  given!(:user){ create(:user) }

  background :each do
    login user
    visit users_path
  end

  scenario "listing users" do
    expect(page).to_not have_content("Lista de Usuários")
    expect(page).to have_content("Acesso Negado")
  end

  scenario "creating a new user" do
    visit new_user_path
    expect(page).to have_content("Acesso Negado")
  end
  
  scenario "showing user" do
    visit "/users/#{user.id}"

    expect(page).to have_content(user.name)
    expect(page).to have_content("Editar")
  end

  scenario "updating user" do
    visit "/users/#{user.id}/edit"

    fill_in "Nome", with: "Marco"
    click_on "Salvar"

    expect(page).to have_content("Usuário atualizado com sucesso")
    expect(page).to have_content("Marco")
  end

  scenario "removing user" do
    expect(page).to have_content("Acesso Negado")
  end

  scenario "signing out" do
    expect(page).to have_content("Acesso Negado")
    click_on "Logout"
    expect(page).to have_content("Logout efetuado com sucesso")
  end
end

feature "users for normal user, trying to access another user profile" do
  given!(:user){ create(:user) }

  background :each do
    login create(:user)
  end
  
  scenario "showing user" do
    visit "/users/#{user.id}"
    expect(page).to_not have_content(user.name)
    expect(page).to_not have_content("Editar")
    expect(page).to have_content("Acesso Negado")
  end

  scenario "updating user" do
    visit "/users/#{user.id}/edit"
    expect(page).to have_content("Acesso Negado")
    expect(page).to_not have_field('Nome')
  end
end
