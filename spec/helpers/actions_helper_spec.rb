require 'rails_helper'

RSpec.describe ActionsHelper, type: :helper do
  describe "actions name" do
    it "index" do
      expect(helper.action_index(User)).to eq( I18n.t('action.index', model: User.model_name.human.pluralize) )
    end

    it "new" do
      expect(helper.action_new(User)).to eq( I18n.t('action.new', model: User.model_name.human) )
    end

    it "new female" do
      expect(helper.action_new_fem(Account)).to eq( I18n.t('action.new_fem', model: Account.model_name.human) )
    end

    it "edit" do
      expect(helper.action_edit(User)).to eq( I18n.t('action.edit', model: User.model_name.human) )
    end
  end
end
