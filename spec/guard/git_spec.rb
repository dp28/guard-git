# frozen_string_literal: true

RSpec.describe Guard::Git do
  it 'has a version number' do
    expect(Guard::Git::VERSION).not_to be nil
  end
end
