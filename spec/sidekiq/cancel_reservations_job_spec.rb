require 'rails_helper'

RSpec.describe CancelReservationsJob, type: :job do
  describe 'perform_later' do
    it 'enqueues job' do
      ActiveJob::Base.queue_adapter = :test
      expect { described_class.perform_later }.to have_enqueued_job
    end
  end

  describe 'perform_now' do
    let(:reservation) { create(:reservation, :reserved) }

    before { reservation }

    it 'cancels outdated reservation' do
      expect { described_class.perform_now }
        .to change { reservation.reload.status }
        .from("reserved")
        .to("canceled")
    end
  end
end