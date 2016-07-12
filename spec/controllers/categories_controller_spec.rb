require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:valid_attributes) { attributes_for(:category) }
  let(:invalid_attributes) { { name: "" } }

  # => I N D E X
  describe "GET #index" do
    context "with user category owner" do
      sign_in_normal_user
      it "assigns all categories as @categories" do
        category = create(:category, user: controller.current_user)
        get :index, {user_id: controller.current_user}
        expect(assigns(:categories)).to eq([category])
        expect(response).to render_template(:index)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access another user categories" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        category = create(:category, user: user)
        get :index, {user_id: user}
        expect(assigns(:categories)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      it "can't access another user categories" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        category = create(:category, user: user)
        get :index, {user_id: user}
        expect(assigns(:categories)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => S H O W
  describe "GET #show" do
    context "with user category owner" do
      sign_in_normal_user
      it "assigns the requested category as @category" do
        category = create(:category, user: controller.current_user)
        get :show, {id: category.to_param}
        expect(assigns(:category)).to eq(category)
        expect(response).to render_template(:show)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access another user category" do
        expect(controller.current_user.admin).to be(true)
        category = create(:category, user: create(:user))
        get :show, {id: category.to_param}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      it "can't access another user categories" do
        expect(controller.current_user.admin).to be(false)
        category = create(:category, user: create(:user))
        get :show, {id: category.to_param}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => N E W
  describe "GET #new" do
    context "with user category owner" do
      sign_in_normal_user
      it "assigns a new category as @category" do
        get :new, {user_id: controller.current_user}
        expect(assigns(:category)).to be_a_new(Category)
        expect(response).to render_template(:new)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access new category form" do
        expect(controller.current_user.admin).to be(true)
        get :new, {user_id: create(:user)}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      it "can't access new category form" do
        expect(controller.current_user.admin).to be(false)
        get :new, {user_id: create(:user)}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # =>  E D I T
  describe "GET #edit" do
    context "with user category owner" do
      sign_in_normal_user
      it "assigns the requested category as @category" do
        category = create(:category, user: controller.current_user)
        get :edit, {id: category.to_param}
        expect(assigns(:category)).to eq(category)
        expect(response).to render_template(:edit)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't access category edit" do
        expect(controller.current_user.admin).to be(true)
        category = create(:category, user: create(:user))
        get :edit, {id: category.to_param}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      it "can't access category edit" do
        expect(controller.current_user.admin).to be(false)
        category = create(:category, user: create(:user))
        get :edit, {id: category.to_param}
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => C R E A T E
  describe "POST #create" do
    context "with user category owner and valid params" do
      sign_in_normal_user
      it "creates a new Category" do
        expect {
          post :create, {user_id: controller.current_user, category: valid_attributes}
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, {user_id: controller.current_user, category: valid_attributes}
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the created category" do
        post :create, {user_id: controller.current_user, category: valid_attributes}
        expect(response).to redirect_to(Category.last)
      end
    end

    context "with user category owner and ivalid params" do
      sign_in_normal_user
      it "assigns a newly created but unsaved category as @category" do
        post :create, {user_id: controller.current_user, category: invalid_attributes}
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        post :create, {user_id: controller.current_user, category: invalid_attributes}
        expect(response).to render_template(:new)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      it "can't create a new Category" do
        expect(controller.current_user.admin).to be(true)
        expect {
          post :create, {user_id: create(:user), category: valid_attributes}
        }.to change(Category, :count).by(0)
      end

      it "can't assigns a newly created category as @category and must redirect_to root" do
        post :create, {user_id: create(:user), category: valid_attributes}
        expect(assigns(:account)).to_not be_a(Category)
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't create a new Category" do
        expect(controller.current_user.admin).to be(false)
        expect {
          post :create, {user_id: create(:user), category: valid_attributes}
        }.to change(Category, :count).by(0)
      end

      it "can't assigns a newly created category as @category and must redirect_to root" do
        post :create, {user_id: create(:user), category: valid_attributes}
        expect(assigns(:account)).to_not be_a(Category)
        expect(assigns(:account)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => U P D A T E
  describe "PUT #update" do
    context "with user category owner and valid params" do
      sign_in_normal_user
      let(:new_attributes) { {name: "Pharmacy"} }

      it "updates the requested category" do
        category = create(:category, user: controller.current_user)
        put :update, {id: category.to_param, category: new_attributes}
        category.reload
        expect(assigns(:category).name).to eq(new_attributes[:name])
      end

      it "assigns the requested category as @category" do
        category = create(:category, user: controller.current_user)
        put :update, {id: category.to_param, category: valid_attributes}
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        category = create(:category, user: controller.current_user)
        put :update, {id: category.to_param, category: valid_attributes}
        expect(response).to redirect_to(category)
      end
    end

    context "with user category owner and invalid params" do
      sign_in_normal_user
      it "assigns the category as @category" do
        category = create(:category, user: controller.current_user)
        put :update, {id: category.to_param, category: invalid_attributes}
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        category = create(:category, user: controller.current_user)
        put :update, {id: category.to_param, category: invalid_attributes}
        expect(response).to render_template(:edit)
      end
    end

    context "with an admin user" do
      sign_in_admin_user
      let(:new_attributes){ {name: "Another category name"} }

      it "can't update the requested category and must redirect_to root" do
        expect(controller.current_user.admin).to be(true)
        category = create(:category, user: create(:user))
        put :update, {id: category.to_param, category: new_attributes}
        category.reload
        expect(assigns(:category)).to_not eq(category)
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      let(:new_attributes){ {name: "Another category name"} }

      it "can't update the requested category and must redirect_to root" do
        expect(controller.current_user.admin).to be(false)
        category = create(:category, user: create(:user))
        put :update, {id: category.to_param, category: new_attributes}
        category.reload
        expect(assigns(:category)).to_not eq(category)
        expect(assigns(:category)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => D E S T R O Y 
  describe "DELETE #destroy" do
    context "with user category owner" do
      sign_in_normal_user

      it "destroys the requested category" do
        category = create(:category, user: controller.current_user)
        expect {
          delete :destroy, {id: category.to_param}
        }.to change(Category, :count).by(-1)
      end

      it "redirects to the categories list" do
        category = create(:category, user: controller.current_user)
        delete :destroy, {id: category.to_param}
        expect(response).to redirect_to(user_categories_url(controller.current_user))
      end
    end

    context "with an admin user" do
      sign_in_admin_user

      it "can't destroy another user category" do
        expect(controller.current_user.admin).to be(true)
        category = create(:category, user: create(:user))
        expect {
          delete :destroy, {id: category.to_param}
        }.to change(Category, :count).by(0)
      end
      
      it "can't destroy and must redirects to root" do
        category = create(:category, user: create(:user))
        delete :destroy, {id: category.to_param}
        category.reload
        expect(category).to be_persisted
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't destroy another user category" do
        expect(controller.current_user.admin).to be(false)
        category = create(:category, user: create(:user))
        expect {
          delete :destroy, {id: category.to_param}
        }.to change(Category, :count).by(0)
      end
      
      it "can't destroy and must redirects to root" do
        category = create(:category, user: create(:user))
        delete :destroy, {id: category.to_param}
        category.reload
        expect(category).to be_persisted
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
