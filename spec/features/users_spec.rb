require 'rails_helper'

# => V I E W S    C O N T E N T
def expect_index
  expect(page).to have_content( I18n.t('action.index', model: User.model_name.human.pluralize) )

  expect(page).to have_content( User.human_attribute_name(:email) )
  expect(page).to have_content(user.email)
  expect(page).to have_content( User.human_attribute_name(:name) )
  expect(page).to have_content(user.name)
  expect(page).to have_content( User.human_attribute_name(:admin) )
  expect(page).to have_css(".fa.fa-check-square-o")
  expect(page).to have_css(".fa.fa-minus")
  expect(page).to have_css('#new_user_button')
  expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
  expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")
end

def expect_new
  expect(page).to have_content( I18n.t('action.new', model: User.model_name.human) )
  expect(page).to have_content( User.human_attribute_name(:email) )
  expect(page).to have_css("input#user_email")
  expect(page).to have_content( User.human_attribute_name(:admin) )
  expect(page).to have_selector("input#user_admin")
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )

  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_edit user
  expect(page).to have_content( I18n.t('action.edit', model: User.model_name.human) )
  expect(page).to have_content(user.email)
  expect(page).to_not have_css("input#user_email")
  expect(page).to have_field( User.human_attribute_name(:name), with: user.name )

  expect(page).to have_content( User.human_attribute_name(:admin) )
  expect(page).to have_selector("input#user_admin")
  if user.admin
    find('input#user_admin').should be_checked
  else
    find('input#user_admin').should_not be_checked
  end

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )

  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_show user
  expect(page).to have_content( User.model_name.human.pluralize )
  expect(page).to have_content(user.name)
  expect(page).to have_content(user.email)
  if user.admin
    expect(page).to have_content( I18n.t('link.text-yes') )
  else
    expect(page).to have_content( I18n.t('link.text-no') )
  end
  expect(page).to have_content(I18n.l user.created_at, format: :long)
  expect(page).to have_content(I18n.l user.updated_at, format: :long)
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.change_password') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.remove_account') )
end

def expect_login
  expect(page).to have_content("Entrar")
  expect(page).to have_css("input#user_email")
  expect(page).to have_css("input#user_password")
  expect(page).to have_content("Continuar Conectado")
  expect(page).to have_selector("input#user_remember_me")
  expect(page).to have_selector(:link_or_button, "Entrar")
  expect(page).to have_content("Ainda não possui cadastrado?")
  expect(page).to have_selector(:link_or_button, "Inscrever-se")
  expect(page).to have_selector(:link_or_button, "Esqueceu sua senha?")
  expect(page).to have_selector(:link_or_button, "Não recebeu instruções de confirmação?")
  expect(page).to have_selector(:link_or_button, "Não recebeu instruções de desbloqueio?")
end

def expect_edit_password
  expect(page).to have_content( User.model_name.human.pluralize )
  expect(page).to have_content( I18n.t('link.change_password') )
  expect(page).to_not have_css("input#user_current_password")
  expect(page).to have_css("input#user_password")
  expect(page).to have_css("input#user_password_confirmation")
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
end

def expect_destroy_account
  expect(page).to have_content("Lembre-se que todos seus dados serão excluídos de nosso banco de dados")
  expect(page).to have_css("input#user_typed_email")
  expect(page).to have_selector(:link_or_button, I18n.t('link.cancel') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.remove_account') )
end



# => A D M I N    U S E R
feature "users views for admin user" do
  given!(:user){ create(:user) }

  background :each do
    login create(:user, admin: true)
  end

  # => I N D E X
  scenario "listing users" do
    visit users_path
    expect_index
  end

  # => N E W    A N D    C R E A T E
  context "creating a new user" do
    scenario "with valid params" do
      visit new_user_path

      expect_new
      fill_in :user_email, with: "luis@simplefinance.com"
      click_on "Salvar"

      expect(page).to have_content("Usuário criado com sucesso")
      expect_show User.find_by(email: "luis@simplefinance.com")
    end

    scenario "with invalid params" do
      visit new_user_path

      fill_in :user_email, with: ""
      click_on "Salvar"

      expect(page).to have_content("Não pode ficar em branco")
      expect_new
    end
  end
  
  # => S H O W
  scenario "showing user" do
    visit "/users/#{user.id}"

    expect_show user
  end

  # => U P D A T E
  context "updating user" do
    scenario "with valid params" do
      visit "/users/#{user.id}/edit"

      expect_edit user
      fill_in :user_name, with: "Marco"
      click_on "Salvar"

      expect(page).to have_content("Usuário atualizado com sucesso")
      expect_show user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}/edit"

      fill_in :user_name, with: ""
      click_on "Salvar"

      expect(page).to have_content("Não pode ficar em branco")
      user.name = ""
      user.save
      expect_edit user
    end
  end

  # => D E S T R O Y
  scenario "removing user" do
    visit users_path

    expect_index
    first('.btn-danger').click

    expect(page).to have_content("Usuário removido com sucesso")
    expect_index
  end

  scenario "signing out" do
    visit users_path

    expect_index
    click_on "Logout"

    expect(page).to have_content("Logout efetuado com sucesso")
    expect_login
  end

  # => U P D A T E    P A S S W O R D
  context "updating user password" do
    scenario "with valid params" do
      visit "/users/#{user.id}"

      expect_show user
      click_on "Editar Senha"
      expect_edit_password

      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "12341234"
      click_on "Salvar"

      expect(page).to have_content("Senha alterada com sucesso")
      expect_show user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}"

      click_on "Editar Senha"
      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "11112222"
      click_on "Salvar"

      expect(page).to have_content("Senha não confere")
      expect_edit_password
    end
  end

  # => D E S T R O Y    A C C O U N T
  context "destroyng user account" do
    scenario "with valid email" do
      visit "/users/#{user.id}"

      expect_show user
      find('a.btn.btn-danger').click
      expect_destroy_account
      fill_in :user_typed_email, with: user.email
      find('button.btn.btn-danger').click

      expect(page).to have_content("Conta excluída com sucesso")
      expect(page).to_not have_content(user.email)
      expect(page).to_not have_content(user.name)
    end

    scenario "with invalid email" do
      visit "/users/#{user.id}"

      find('a.btn.btn-danger').click
      fill_in :user_typed_email, with: "Anything"
      find('button.btn.btn-danger').click

      expect(page).to have_content("E-mail Inválido")
      expect_show user
    end
  end
end






# REVISED TILL HERE 

# => N O R M A L    U S E R
feature "users view for current  user" do
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



# => A N O T H E R    N O R M A L    U S E R
feature "users views for normal user, trying to access another user profile" do
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
