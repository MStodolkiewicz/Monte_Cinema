require 'rails_helper'

RSpec.describe CancelReservationsJob, type: :job do
  describe 'perform_now' do
    let(:reservation) { create :reservation, seance_id: seance.id }
    context 'when seance starts less than 30 minutes from now' do
      let(:seance) { create :seance, start_time: 25.minute.from_now }
      it 'cancels reservations' do
        expect { described_class.perform_now }.to change { reservation.reload.status }.from('reserved').to('canceled')
      end
    end

    context 'when seance starts 30 minutes from now' do
      let(:seance) { create :seance, start_time: 30.minute.from_now }
      it 'cancels reservations' do
        expect { described_class.perform_now }.to change { reservation.reload.status }.from('reserved').to('canceled')
      end
    end

    context 'when seance starts more than 30 minutes from now' do
      let(:seance) { create :seance, start_time: 35.minute.from_now }
      it 'does not cancel reservation' do
        expect { described_class.perform_now }.not_to(change { reservation.status })
      end
    end
  end
end
