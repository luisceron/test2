require 'rails_helper'

RSpec.describe AccountsController, type: :controller do

  let(:valid_attributes){ attributes_for(:account) }

  let(:invalid_attributes){ {name: ""} }

  # => I N D E X
  describe "GET #index" do
    context "with user account owner" do
      sign_in_normal_user
      it "assigns all accounts as @accounts" do
        account = create(:account, user: controller.current_user)
        get :index, {user_id: controller.current_user}
        expect(assigns(:accounts)).to eq([account])
        expect(response).to render_template(:index)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access the list of other user accounts" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        create(:account, user: user)
        get :index, {user_id: user}
        expect(assigns(:accounts)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      it "can't access the list of other user accounts" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        create(:account, user: user)
        get :index, {user_id: user}
        expect(assigns(:accounts)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => S H O W
  describe "GET #show" do
    context "with user account owner" do
      sign_in_normal_user
      it "assigns the requested account as @account" do
        account = create(:account, user: controller.current_user)
        get :show, {id: account.to_param}
        expect(assigns(:account)).to eq(account)
        expect(response).to render_template(:show)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access another user's account" do
        expect(controller.current_user.admin).to be(true)
        account = create(:account, user: create(:user))
        get :show, {id: account.to_param}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      it "can't access another user's account" do
        expect(controller.current_user.admin).to be(false)
        account = create(:account, user: create(:user))
        get :show, {id: account.to_param}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => N E W
  describe "GET #new" do
    context "with user account owner" do
      sign_in_normal_user
      it "assigns a new account as @account" do
        get :new, {user_id: controller.current_user}
        expect(assigns(:account)).to be_a_new(Account)
        expect(response).to render_template(:new)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access new template and redirect_to root" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        get :new, {user_id: user}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      it "can't access new template and redirect_to root" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        get :new, {user_id: user}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => E D I T
  describe "GET #edit" do
    context "with user account owner" do
      sign_in_normal_user
      it "assigns the requested account as @account" do
        account = create(:account, user: controller.current_user)
        get :edit, {id: account.to_param}
        expect(assigns(:account)).to eq(account)
        expect(response).to render_template(:edit)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access account edit" do
        expect(controller.current_user.admin).to be(true)
        account = create(:account, user: create(:user))
        get :edit, {id: account.to_param}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      it "can't access account edit" do
        expect(controller.current_user.admin).to be(false)
        account = create(:account, user: create(:user))
        get :edit, {id: account.to_param}
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => C R E A T E
  describe "POST #create" do
    context "with user account owner and valid params" do
      sign_in_normal_user
      it "creates a new Account" do
        expect {
          post :create, {user_id: controller.current_user, account: valid_attributes}
        }.to change(Account, :count).by(1)
      end

      it "assigns a newly created account as @account" do
        post :create, {user_id: controller.current_user, account: valid_attributes}
        expect(assigns(:account)).to be_a(Account)
        expect(assigns(:account)).to be_persisted
      end

      it "redirects to the created account" do
        post :create, {user_id: controller.current_user, account: valid_attributes}
        expect(response).to redirect_to(Account.last)
      end
    end

    context "with user account owner and invalid params" do
      sign_in_normal_user
      it "assigns a newly created but unsaved account as @account" do
        post :create, {user_id: controller.current_user, account: invalid_attributes}
        expect(assigns(:account)).to be_a_new(Account)
      end

      it "re-renders the 'new' template" do
        post :create, {user_id: controller.current_user, account: invalid_attributes}
        expect(response).to render_template(:new)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't creates a new Account" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        expect {
          post :create, {user_id: user.id, account: valid_attributes}
        }.to change(Account, :count).by(0)
      end

      it "can't assigns a newly created account as @account and must redict_to root" do
        user = create(:user)
        post :create, {user_id: user.id, account: valid_attributes}
        expect(assigns(:account)).to_not be_a(Account)
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      it "can't creates a new Account" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        expect {
          post :create, {user_id: user.id, account: valid_attributes}
        }.to change(Account, :count).by(0)
      end

      it "can't assigns a newly created account as @account and must redict_to root" do
        user = create(:user)
        post :create, {user_id: user.id, account: valid_attributes}
        expect(assigns(:account)).to_not be_a(Account)
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => U P D A T E
  describe "PUT #update" do
    context "with user account owner and valid params" do
      sign_in_normal_user
      let(:new_attributes){ {name: "Another account name"} }

      it "updates the requested account" do
        account = create(:account, user: controller.current_user)
        put :update, {id: account.to_param, account: new_attributes}
        account.reload
        expect(assigns(:account).name).to eq(new_attributes[:name])
      end

      it "assigns the requested account as @account" do
        account = create(:account, user: controller.current_user)
        put :update, {id: account.to_param, account: valid_attributes}
        expect(assigns(:account)).to eq(account)
      end

      it "redirects to the account" do
        account = create(:account, user: controller.current_user)
        put :update, {id: account.to_param, account: valid_attributes}
        expect(response).to redirect_to(account)
      end
    end

    context "with user account owner and invalid params" do
      sign_in_normal_user
      it "assigns the account as @account" do
        account = create(:account, user: controller.current_user)
        put :update, {id: account.to_param, account: invalid_attributes}
        expect(assigns(:account)).to eq(account)
      end

      it "re-renders the 'edit' template" do
        account = create(:account, user: controller.current_user)
        put :update, {id: account.to_param, account: invalid_attributes}
        expect(response).to render_template(:edit)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      let(:new_attributes){ {name: "Another account name"} }

      it "can't updates the requested account and must redirect_to root" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        account = create(:account, user: user)
        put :update, {id: account.to_param, account: new_attributes}
        account.reload
        expect(assigns(:account)).to be_nil
        expect(assigns(:account)).to_not eq(account)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user
      let(:new_attributes){ {name: "Another account name"} }

      it "can't updates the requested account and must redirect_to root" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        account = create(:account, user: user)
        put :update, {id: account.to_param, account: new_attributes}
        account.reload
        expect(assigns(:account)).to be_nil
        expect(assigns(:account)).to_not eq(account)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => D E S T R O Y
  describe "DELETE #destroy" do
    context "with user account owner" do
      sign_in_normal_user

      it "destroys the requested account" do
        account = create(:account, user: controller.current_user)
        expect {
          delete :destroy, {id: account.to_param}
        }.to change(Account, :count).by(-1)
      end

      it "redirects to the accounts list" do
        account = create(:account, user: controller.current_user)
        delete :destroy, {id: account.to_param}
        expect(response).to redirect_to(user_accounts_url(controller.current_user))
      end
    end

    context "with an admin user" do
      sign_in_admin_user

      it "can't destroy another user's account" do
        expect(controller.current_user.admin).to be(true)
        account = create(:account, user: create(:user))
        expect {
          delete :destroy, {id: account.to_param}
        }.to change(Account, :count).by(0)
      end

      it "can't destroy and must redirects to the root" do
        account = create(:account, user: create(:user))
        delete :destroy, {id: account.to_param}
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an another normal user" do
      sign_in_normal_user

      it "can't destroy another user's account" do
        expect(controller.current_user.admin).to be(false)
        account = create(:account, user: create(:user))
        expect {
          delete :destroy, {id: account.to_param}
        }.to change(Account, :count).by(0)
      end

      it "can't destroy and must redirects to the root" do
        account = create(:account, user: create(:user))
        delete :destroy, {id: account.to_param}
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
