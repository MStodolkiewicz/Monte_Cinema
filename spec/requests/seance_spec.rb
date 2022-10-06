require 'rails_helper'

RSpec.describe "/seances", type: :request do
  let(:user) { create :user }
  let(:manager) { create :user, email: "testmanager@test.com", role: :manager }

  describe "GET /seances/new" do
    subject(:request) { get('/seances/new') }
    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before do
        sign_in user
        request
      end
      it "redirects to root" do
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before do
        sign_in manager
        request
      end
      it "returns successful response" do
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        expect(response).to render_template("seances/new")
      end
    end
  end

  describe "POST /seances" do
    subject(:request) { post('/seances', params:) }
    
    let(:movie) { create :movie }
    let(:hall) { create :hall }

    let(:params) { { seance: attributes_for(:seance, start_time: DateTime.current, price:, movie_id: movie.id, hall_id: hall.id ) } }

    let(:price) { Faker::Number.number(digits: 2) }

    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "does not create a seance record" do
        expect(Seance.count).to eq(0)
      end
    end

    context "when user without permission" do
      before do
        sign_in user
        request
      end
      it "redirects to root" do
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "does not create a seance record" do
        expect(Seance.count).to eq(0)
      end
    end

    context "when user with permission" do
      before do
        sign_in manager
        request
      end
      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        expect(response).to redirect_to("/movies/#{movie.id}")
      end

      it "creates seance record" do
        expect(Seance.where(id: assigns(:seance).id).count).to eq(1)
      end
    end

    context "when price invalid" do
      before do
        sign_in manager
        request
      end
      let(:price) { nil }

      it "doesn't create seance record" do
        expect(Seance.count).to eq(0)
      end

      it "returns unsuccessful response" do
        post("/seances", params:)
        expect(response.status).to eq(422)
      end
    end

    context "when hall used" do
      before do
        sign_in manager
        request
      end

      it "doesn't create seance record" do
        post("/seances", params:)
        expect(Seance.count).to eq(1)
      end

      it "returns unsuccessful response" do
        post("/seances", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET /seances/seance_id/edit" do
    subject(:request) { get("/seances/#{seance.id}/edit") }
    let(:seance) { create :seance }
    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before do
        sign_in user
        request
      end
      it "redirects to root" do
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before do
        sign_in manager
        request
      end
      it "returns successful response" do
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        expect(response).to render_template("seances/edit")
      end
    end
  end

  describe "PATCH /seances/seance_id" do
    subject(:request) { patch("/seances/#{seance.id}", params:) }
    let(:seance) { create :seance }

    let(:params) { { seance: attributes_for(:seance, start_time:, price:, movie_id: movie.id, hall_id: hall.id ) } }
    let(:movie) { create :movie }
    let(:hall) { create :hall }

    let(:price) { Faker::Number.number(digits: 2) }
    let(:start_time) { DateTime.current }

    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before do
        sign_in user
        request
      end
      it "redirects to root" do
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before do
        sign_in manager
        request
      end
      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        expect(response).to redirect_to("/movies/#{movie.id}")
      end

      it "updates seance price" do
        expect(Seance.where(id: seance.id).pluck(:price)).to eq([price])
      end
      it "updates movie" do
        expect(Seance.where(id: seance.id).pluck(:movie_id)).to eq([movie.id])
      end
      it "updates hall" do
        expect(Seance.where(id: seance.id).pluck(:hall_id)).to eq([hall.id])
      end
    end

    context "when price invalid" do
      before do
        sign_in manager
        request
      end
      let(:price) { "s" }

      it "doesn't update seance record" do
        expect(Seance.where(id: seance.id).pluck(:price)).not_to eq([price])
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422)
      end
    end

    context "when start_time invalid" do
      before do
        sign_in manager
        request
      end

      let(:start_time) { nil }

      it "doesn't update seance record" do
        expect(Seance.where(id: seance.id).pluck(:start_time)).not_to eq([start_time])
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /seances/seance_id" do
    subject(:request) { delete("/seances/#{seance.id}") }
    let(:seance) { create :seance }

    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before do
        sign_in user
        request
      end
      it "redirects to root" do
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      let(:admin) { create :user, email: "testadmin@test.com", role: 2 }
      before do
        sign_in admin
        request
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        expect(response).to redirect_to("/movies/#{seance.movie_id}")
      end

      it "destroy seance record" do
        expect(Seance.where(id: seance.id).count).to eq(0)
      end
    end
  end
end
