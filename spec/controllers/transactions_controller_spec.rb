require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:valid_attributes) { 
    attributes_for(:transaction)
      .merge( {account_id:  create(:account).id} )
      .merge( {category_id: create(:category).id} )
  }

  let(:invalid_attributes) { {amount: "", date: ""} }

  # => I N D E X
  describe "GET #index" do
    context "with user transaction owner" do
      sign_in_normal_user

      it "assigns all transactions as @transactions" do
        transaction = create(:transaction, user: controller.current_user)
        get :index, {user_id: controller.current_user}
        expect(assigns(:transactions)).to eq([transaction])
        expect(response).to render_template(:index)
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't assign transactions of another user and must redirect to root" do
        expect(controller.current_user.admin).to be(true)
        user = create(:user)
        transaction = create(:transaction, user: user)
        get :index, {user_id: user}
        expect(assigns(:transactions)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't assign transactions of another user and must redirect to root" do
        expect(controller.current_user.admin).to be(false)
        user = create(:user)
        transaction = create(:transaction, user: user)
        get :index, {user_id: user}
        expect(assigns(:transactions)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => I N D E X    B Y   S E A R C H
  describe "GET #index" do
    context "searching by" do
      let(:user) { create(:user, :normal, email: "user_transactions_test@ceron.com") }

      let(:a1) { create(:account, user: user, name: "Account1") }
      let(:a2) { create(:account, user: user, name: "Account2") }

      let(:c1) { create(:category, user: user, name: "Category1") }
      let(:c2) { create(:category, user: user, name: "Category2") }

      let(:t1) { create(:transaction, user: user, description: "T1", account: a1, category: c2, transaction_type: :out, date: "01/01/2016") }
      let(:t2) { create(:transaction, user: user, description: "T2", account: a2, category: c1, transaction_type: :in,  date: "02/02/2016") }
      let(:t3) { create(:transaction, user: user, description: "T3", account: a1, category: c1, transaction_type: :out, date: "03/03/2016") }
      let(:t4) { create(:transaction, user: user, description: "T4", account: a2, category: c2, transaction_type: :out, date: "04/04/2016") }
      let(:t5) { create(:transaction, user: user, description: "T5", account: a1, category: c1, transaction_type: :in,  date: "05/05/2016") }
      
      before do
        sign_in user
      end

      it "description" do
        get :index, {user_id: user, q: {description_cont: t1.description}}
        expect(assigns(:transactions).to_a).to     include(t1)
        expect(assigns(:transactions).to_a).to_not include(t2, t3, t4, t5)
        expect(response).to render_template(:index)
      end

      it "account" do
        get :index, {user_id: user, q: {account_eq: t2.account.id}}
        expect(assigns(:transactions)).to     include(t2, t4)
        expect(assigns(:transactions)).to_not include(t1, t3, t5)
        expect(response).to render_template(:index)
      end

      it "category" do
        get :index, {user_id: user, q: {category_eq: t3.category.id}}
        expect(assigns(:transactions)).to     include(t2, t3, t5)
        expect(assigns(:transactions)).to_not include(t1, t4)
        expect(response).to render_template(:index)
      end

      it "transaction type" do
        get :index, {user_id: user, q: {transaction_type_eq: Transaction.transaction_types[t4.transaction_type]}}
        expect(assigns(:transactions)).to     include(t1, t3, t4)
        expect(assigns(:transactions)).to_not include(t2, t5)
        expect(response).to render_template(:index)
      end

      it "date" do
        get :index, {user_id: user, q: {date_gteq: t3.date, date_lteq: t5.date}}
        expect(assigns(:transactions)).to     include(t3, t4, t5)
        expect(assigns(:transactions)).to_not include(t1, t2)
        expect(response).to render_template(:index)
      end
    end
  end

  # => S H O W
  describe "GET #show" do
    context "with user transaction owner" do
      sign_in_normal_user

      it "assigns the requested transaction as @transaction" do
        transaction = create(:transaction, user: controller.current_user)
        get :show, {id: transaction.to_param}
        expect(assigns(:transaction)).to eq(transaction)
        expect(response).to render_template(:show)
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't assign another user transaction and must redirect to root" do
        expect(controller.current_user.admin).to be(true)
        transaction = create(:transaction, user: create(:user))
        get :show, {id: transaction.to_param}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't assign another user transaction and must redirect to root" do
        expect(controller.current_user.admin).to be(false)
        transaction = create(:transaction, user: create(:user))
        get :show, {id: transaction.to_param}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => N E W
  describe "GET #new" do
    context "with user transaction owner" do
      sign_in_normal_user

      it "assigns a new transaction as @transaction" do
        get :new, {user_id: controller.current_user}
        expect(assigns(:transaction)).to be_a_new(Transaction)
        expect(response).to render_template(:new)
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't assign a new transaction and must redirect to root" do
        expect(controller.current_user.admin).to be(true)
        get :new, {user_id: create(:user)}
        expect(assigns(:transaction)).to_not be_a_new(Transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't assign a new transaction and must redirect to root" do
        expect(controller.current_user.admin).to be(false)
        get :new, {user_id: create(:user)}
        expect(assigns(:transaction)).to_not be_a_new(Transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => E D I T
  describe "GET #edit" do
    context "with user transaction owner" do
      sign_in_normal_user

      it "assigns the requested transaction as @transaction" do
        transaction = create(:transaction, user: controller.current_user)
        get :edit, {id: transaction.to_param}
        expect(assigns(:transaction)).to eq(transaction)
        expect(response).to render_template(:edit)
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't assign requested transaction of another user to edit" do
        expect(controller.current_user.admin).to be(true)
        transaction = create(:transaction, user: create(:user))
        get :edit, {id: transaction.to_param}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't assign requested transaction of another user to edit" do
        expect(controller.current_user.admin).to be(false)
        transaction = create(:transaction, user: create(:user))
        get :edit, {id: transaction.to_param}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => C R E A T E
  describe "POST #create" do
    context "with user transaction owner and valid params" do
      sign_in_normal_user

      it "creates a new Transaction" do
        expect {
          post :create, {user_id: controller.current_user, transaction: valid_attributes}
        }.to change(Transaction, :count).by(1)
      end

      it "assigns a newly created transaction as @transaction" do
        post :create, {user_id: controller.current_user, transaction: valid_attributes}
        expect(assigns(:transaction)).to be_a(Transaction)
        expect(assigns(:transaction)).to be_persisted
      end

      it "redirects to the created transaction" do
        post :create, {user_id: controller.current_user, transaction: valid_attributes}
        expect(response).to redirect_to(user_transactions_url(controller.current_user))
      end
    end

    context "with user transaction owner and invalid params" do
      sign_in_normal_user

      it "assigns a newly created but unsaved transaction as @transaction" do
        post :create, {user_id: controller.current_user, transaction: invalid_attributes}
        expect(assigns(:transaction)).to be_a_new(Transaction)
      end

      it "re-renders the 'new' template" do
        post :create, {user_id: controller.current_user, transaction: invalid_attributes}
        expect(response).to render_template(:new)
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't create a new Transaction for another user" do
        expect(controller.current_user.admin).to be(true)
        expect {
          post :create, {user_id: create(:user), transaction: valid_attributes}
        }.to change(Transaction, :count).by(0)
      end

      it "can't create transaction and must redirect to root" do
        post :create, {user_id: create(:user), transaction: valid_attributes}
        expect(assigns(:transaction)).to_not be_a(Transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't create a new Transaction for another user" do
        expect(controller.current_user.admin).to be(false)
        expect {
          post :create, {user_id: create(:user), transaction: valid_attributes}
        }.to change(Transaction, :count).by(0)
      end

      it "can't create transaction and must redirect to root" do
        post :create, {user_id: create(:user), transaction: valid_attributes}
        expect(assigns(:transaction)).to_not be_a(Transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => U P D A T E
  describe "PUT #update" do
    context "with user transaction owner and valid params" do
      sign_in_normal_user
      let(:new_attributes) { {description: "New description"} }

      it "updates the requested transaction" do
        transaction = create(:transaction, user: controller.current_user)
        put :update, {id: transaction.to_param, transaction: new_attributes}
        transaction.reload
        expect(assigns(:transaction).description).to eq(new_attributes[:description])
      end

      it "assigns the requested transaction as @transaction" do
        transaction = create(:transaction, user: controller.current_user)
        put :update, {id: transaction.to_param, transaction: valid_attributes}
        expect(assigns(:transaction)).to eq(transaction)
      end

      it "redirects to the transaction" do
        transaction = create(:transaction, user: controller.current_user)
        put :update, {id: transaction.to_param, transaction: valid_attributes}
        expect(response).to redirect_to(user_transactions_url(controller.current_user))
      end
    end

    context "with user transaction owner and invalid params" do
      sign_in_normal_user

      it "assigns the transaction as @transaction" do
        transaction = create(:transaction, user: controller.current_user)
        put :update, {id: transaction.to_param, transaction: invalid_attributes}
        expect(assigns(:transaction)).to eq(transaction)
      end

      it "re-renders the 'edit' template" do
        transaction = create(:transaction, user: controller.current_user)
        put :update, {id: transaction.to_param, transaction: invalid_attributes}
        expect(response).to render_template(:edit)
      end
    end

    context "with user admin" do
      sign_in_admin_user
      let(:new_attributes){ {description: "Another new description"} }

      it "can't edit another user transaction" do
        expect(controller.current_user.admin).to be(true)
        transaction = create(:transaction, user: create(:user))
        put :update, {id: transaction.to_param, transaction: valid_attributes}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user
      let(:new_attributes){ {description: "Another new description"} }

      it "can't edit another user transaction" do
        expect(controller.current_user.admin).to be(false)
        transaction = create(:transaction, user: create(:user))
        put :update, {id: transaction.to_param, transaction: valid_attributes}
        expect(assigns(:transaction)).to_not eq(transaction)
        expect(assigns(:transaction)).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # => D E S T R O Y
  describe "DELETE #destroy" do
    context "with user transaction owner" do
      sign_in_normal_user

      it "destroys the requested transaction" do
        transaction = create(:transaction, user: controller.current_user)
        expect {
          delete :destroy, {id: transaction.to_param}
        }.to change(Transaction, :count).by(-1)
      end

      it "redirects to the transactions list" do
        transaction = create(:transaction, user: controller.current_user)
        delete :destroy, {id: transaction.to_param}
        expect(response).to redirect_to(user_transactions_url(controller.current_user))
      end
    end

    context "with user admin" do
      sign_in_admin_user 

      it "can't destroy another user transaction" do
        expect(controller.current_user.admin).to be(true)
        transaction = create(:transaction, user: create(:user))
        expect {
          delete :destroy, {id: transaction.to_param}
        }.to change(Transaction, :count).by(0)
      end

      it "can't destroy another user transaction and must redirect to root" do
        transaction = create(:transaction, user: create(:user))
        delete :destroy, {id: transaction.to_param}
        transaction.reload
        expect(transaction).to be_persisted
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another normal user" do
      sign_in_normal_user

      it "can't destroy another user transaction" do
        expect(controller.current_user.admin).to be(false)
        transaction = create(:transaction, user: create(:user))
        expect {
          delete :destroy, {id: transaction.to_param}
        }.to change(Transaction, :count).by(0)
      end

      it "can't destroy another user transaction and must redirect to root" do
        transaction = create(:transaction, user: create(:user))
        delete :destroy, {id: transaction.to_param}
        transaction.reload
        expect(transaction).to be_persisted
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
