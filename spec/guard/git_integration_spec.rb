# frozen_string_literal: true

require 'support/guard_process'
require 'support/branches'

RSpec.describe Guard::Git do
  describe 'when files change because the branch is changed' do
    before do
      Branches.change_to_default
      GuardProcess.ensure_is_running
    end

    it 'does not trigger guard' do
      triggered = GuardProcess.triggered_by? { Branches.change_to_non_default }
      expect(triggered).to be false
    end
  end
end
