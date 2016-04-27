require 'rails_helper'

RSpec.describe User, type: :model do
  it 'must validate required attributes' do
    expect(subject).to validate_presence_of(:email)
    expect(subject).to validate_presence_of(:name)
  end
end
