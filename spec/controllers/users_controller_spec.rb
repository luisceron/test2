require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes){ attributes_for(:user) }

  let(:invalid_attributes){ {email: ""} }

  let(:valid_session){ {} }

  # => I N D E X
  describe "GET #index" do
    context "admin user" do
      sign_in_admin_user
      it "assigns all users as @users" do
        expect(controller.current_user.admin).to be(true)
        User.create! valid_attributes
        get :index, {}
        expect(assigns(:users)).to match_array(User.all)
        expect(response).to render_template(:index)
      end

      it "search must return only matched records" do
        expect(controller.current_user.admin).to be(true)
        user1 = create(:user, email: "user_test1@test.com")
        user2 = create(:user, email: "user_test2@test.com")
        user3 = create(:user, email: "user_test3@test.com")
        get :index, { q: {email_or_name_cont: user1.email} }
        expect(assigns(:users)).to eq([user1])
        expect(response).to render_template(:index)
      end
    end

    context "normal user" do
      sign_in_normal_user
      it "try to assigns all users as normal user" do
        expect(controller.current_user.admin).to be(false)
        get :index, {}
        expect(assigns(:users)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => S H O W
  describe "GET #show" do
    context "admin user" do
      sign_in_admin_user
      it "assigns the requested user as @user" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        get :show, {:id => user.to_param}, valid_session
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template(:show)
      end
    end

    context "current normal user" do
      sign_in_normal_user
      it "assigns the requested user as @user" do
        expect(controller.current_user.admin).to be(false)
        get :show, {:id => controller.current_user.to_param}, valid_session
        expect(assigns(:user)).to eq(controller.current_user)
        expect(response).to render_template(:show)
      end
    end

    context "another normal user" do
      sign_in_normal_user
      it "assigns the requested user as @user" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes
        get :show, {:id => user.to_param}, valid_session
        expect(assigns(:user)).to be_nil
        expect(assigns(:user)).to_not eq(user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => N E W
  describe "GET #new" do
    context "admin user" do
      sign_in_admin_user
      it "assigns a new user as @user" do
        expect(controller.current_user.admin).to be(true)
        get :new, {}, valid_session
        expect(assigns(:user)).to be_a_new(User)
        expect(response).to render_template(:new)
      end
    end

    context "normal user" do
      sign_in_normal_user
      it "should not assigns a new user as @user" do
        expect(controller.current_user.admin).to be(false)
        get :new, {}, valid_session
        expect(assigns(:user)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => E D I T
  describe "GET #edit" do
    context "admin user" do
      sign_in_admin_user
      it "assigns the requested user as @user" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        get :edit, {:id => user.to_param}, valid_session
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template(:edit)
      end
    end

    context "current normal user" do
      sign_in_normal_user
      it "assigns the current user as @user" do
        expect(controller.current_user.admin).to be(false)
        get :edit, {:id => controller.current_user.to_param}, valid_session
        expect(assigns(:user)).to eq(controller.current_user)
        expect(response).to render_template(:edit)
      end
    end

    context "another normal user" do
      sign_in_normal_user
      it "should not assigns the requested user as @user" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes
        get :edit, {:id => user.to_param}, valid_session
        expect(assigns(:user)).to_not eq(user)
        expect(assigns(:user)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => C R E A T E
  describe "POST #create" do

    # => C R E A T E    A D M I N   U S E R
    context "admin with valid params" do
      sign_in_admin_user
      it "creates a new User" do
        expect(controller.current_user.admin).to be(true)
        expect {
          post :create, {:user => valid_attributes}, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}, valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, {:user => valid_attributes}, valid_session
        expect(response).to redirect_to(User.last)
      end
    end

    context "admin with invalid params" do
      sign_in_admin_user
      it "assigns a newly created but unsaved user as @user" do
        expect(controller.current_user.admin).to be(true)
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user)).to_not be_persisted
      end

      it "re-renders the 'new' template" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end

    # => C R E A T E    N O R M A L   U S E R
    context "normal user" do
      sign_in_normal_user
      it "try to creates a new User, should not change User" do
        expect(controller.current_user.admin).to be(false)
        expect{
          post :create, {user: valid_attributes}
        }.to change(User, :count).by(0)
      end

      it "try to creates a new User, should there's not object and return to root" do
        post :create, {user: valid_attributes}
        expect(assigns(:user)).to be_nil
        expect(response).to redirect_to root_path
      end
    end
  end

  # => U P D A T E
  describe "PUT #update" do
    let(:new_attributes) { {name: "Ceron2"} }

    # => U P D A T E    A D M I N   U S E R
    context "admin with valid params" do
      sign_in_admin_user

      it "updates the requested user" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        user.reload
        expect(user.name).to eq(new_attributes[:name])
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(response).to redirect_to(user)
      end
    end

    context "admin with invalid params" do
      sign_in_admin_user
      it "assigns the user as @user" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(response).to render_template(:edit)
      end
    end

    # => U P D A T E    N O R M A L   U S E R
    context "normal user with valid params" do
      sign_in_normal_user

      it "updates current user" do
        expect(controller.current_user.admin).to be(false)
        put :update, {:id => controller.current_user.to_param, :user => new_attributes}, valid_session
        controller.current_user.reload
        expect(controller.current_user.name).to eq(new_attributes[:name])
      end

      it "assigns the currente user as @user" do
        put :update, {:id => controller.current_user.to_param, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(controller.current_user)
      end

      it "redirects to the user" do
        put :update, {:id => controller.current_user.to_param, :user => valid_attributes}, valid_session
        expect(response).to redirect_to(controller.current_user)
      end
    end

    context "normal user with invalid params" do
      sign_in_normal_user

      it "assigns the current user as @user" do
        expect(controller.current_user.admin).to be(false)
        put :update, {:id => controller.current_user.to_param, :user => invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(controller.current_user)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => controller.current_user.to_param, :user => invalid_attributes}, valid_session
        expect(response).to render_template(:edit)
      end
    end

    # => U P D A T E    A N O T H E R   U S E R
    context "another normal user trying to edit a user" do
      sign_in_normal_user

      it "should not have chagend user and return to root" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        expect(assigns(:user)).to be_nil
        expect(response).to redirect_to root_path
      end
    end
  end

  # => D E S T R O Y
  describe "DELETE #destroy" do
    context "admin" do
      sign_in_admin_user

      it "destroys the requested user" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        expect {
          delete :destroy, {:id => user.to_param}, valid_session
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        user = User.create! valid_attributes
        delete :destroy, {:id => user.to_param}, valid_session
        expect(response).to redirect_to(users_url)
      end
    end

    context "normal user" do
      sign_in_normal_user

      it "should not destroy any user" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes

        expect {
          delete :destroy, {:id => user.to_param}, valid_session
        }.to change(User, :count).by(0)

        delete :destroy, {:id => user.to_param}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => E D I T   P A S S W O R D
  describe "EDIT_PASSWORD #edit_password" do
    context "admin user" do
      sign_in_admin_user

      it "assigns the requested user as @user and go to edit_password" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        get :edit_password, {user_id: user.id}
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template(:edit_password)
      end
    end

    context "normal user" do
      sign_in_normal_user
      it "assigns the current user as @user and go to edit_password" do
        expect(controller.current_user.admin).to be(false)
        get :edit_password, {user_id: controller.current_user.id}
        expect(assigns(:user)).to eq(controller.current_user)
        expect(response).to render_template(:edit_password)
      end
    end

    context "another normal user" do
      sign_in_normal_user
      it "should not assigns the requested user as @user and go to root" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes
        get :edit_password, {user_id: user.to_param}
        expect(assigns(:user)).to_not eq(user)
        expect(assigns(:user)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => U P D A T E   P A S S W O R D
  describe "UPDATE_PASSWORD #update_password" do
    let(:new_password){ {password: 'new_password', password_confirmation: 'new_password'} }
    let(:invalid_new_password){ {password: 'new_password', password_confirmation: 'invalid_password'}}

    context "admin user" do
      sign_in_admin_user

      it "must update user's password with a new password without validate current password" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        put :update_password, {user_id: user.id, user: new_password}
        expect(response).to redirect_to(user)
      end

      it "with different password confirmation, must not update user's password and return to edit password" do
        user = User.create! valid_attributes
        put :update_password, {user_id: user.id, user: invalid_new_password}
        expect(response).to render_template(:edit_password)
      end

      it "must update admin password" do
        put :update_password, {user_id: controller.current_user.id, user: new_password}
        expect(response).to redirect_to(controller.current_user)
      end
    end

    context "normal user" do
      sign_in_normal_user

      it "must update current user's password and redirect to user profile" do
        expect(controller.current_user.admin).to be(false)
        put :update_password, {user_id: controller.current_user.id, user: new_password.merge({current_password: '12341234'}) }
        expect(response).to redirect_to(controller.current_user)
      end

      it "with invalid current password, must not update current user's password and return to edit password" do
        put :update_password, {user_id: controller.current_user.id, user: new_password.merge({current_password: '11112222'}) }
        expect(response).to render_template(:edit_password)
      end

      it "with different password confirmation, must not update current user's password and return to edit password" do
        put :update_password, {user_id: controller.current_user.id, user: invalid_new_password.merge({current_password: '12341234'}) }
        expect(response).to render_template(:edit_password)
      end
    end

    context "another normal user" do
      sign_in_normal_user

      it "must not update user's password and redirect to root" do
        expect(controller.current_user.admin).to be(false)

        user = User.create! valid_attributes
        put :update_password, {user_id: user.id, user: new_password.merge({current_password: '12341234'}) }
        expect(response).to redirect_to root_path
      end
    end
  end

  # # => R E M O V E   A C C O U N T
  describe "REMOVE_ACCOUNT #remove_account" do
    context "admin" do
      sign_in_admin_user

      it "must remove an user account and redirect to users list" do
        expect(controller.current_user.admin).to be(true)
        user = User.create! valid_attributes
        put :remove_account, {user_id: user.id, user: {typed_email: user.email} }
        expect(User.where(id: user.id).first).to be_nil
        expect(response).to redirect_to users_path
      end

      it "must remove the current admin account and redirect to login" do
        put :remove_account, {user_id: controller.current_user.id, user: {typed_email: controller.current_user.email} }
        expect(User.where(id: controller.current_user.id).first).to be_nil
        expect(response).to redirect_to new_user_session_path
      end

      it "with invalid email, must not remove account and redirect to user profile" do
        user = User.create! valid_attributes
        put :remove_account, {user_id: user.id, user: {typed_email: 'anything'} }
        expect(User.find(user.id)).to_not be_nil
        expect(response).to redirect_to user
      end
    end

    context "normal user" do
      sign_in_normal_user

      it "must remove account and redirect to login" do
        expect(controller.current_user.admin).to be(false)
        put :remove_account, {user_id: controller.current_user.id, user: {typed_email: controller.current_user.email} }
        expect(User.where(id: controller.current_user.id).first).to be_nil
        expect(response).to redirect_to new_user_session_path
      end

      it "with invalid email, must not remove account and redirect to user profile" do
        put :remove_account, {user_id: controller.current_user.id, user: {typed_email: 'anything'} }
        expect(User.find(controller.current_user.id)).to_not be_nil
        expect(response).to redirect_to controller.current_user
      end
    end

    context "another normal user" do
      sign_in_normal_user

      it "must not remove an user account and must redirect root" do
        expect(controller.current_user.admin).to be(false)
        user = User.create! valid_attributes
        put :remove_account, {user_id: user.id, user: {typed_email: user.email} }
        expect(User.find(user.id)).to_not be_nil
        expect(response).to redirect_to root_path
      end
    end
  end
end
