require 'rails_helper'

RSpec.describe "/seances", type: :request do
  let(:user) { create :user }
  let(:manager) { create :user, email: "testmanager@test.com", role: :manager }

  describe "GET /seances/new" do
    context "when no user" do
      it "redirects to sign_in" do
        get("/seances/new")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/seances/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/seances/new")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/seances/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/seances/new")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/seances/new")
        expect(response).to render_template("seances/new")
      end
    end
  end

  describe "POST /seances" do
    let(:params) do
      {
        seance: {
          start_time:,
          price:,
          movie_id:,
          hall_id:
        }
      }
    end
    let(:movie) { create :movie }
    let(:hall) { create :hall }

    let(:hall_id) { hall.id }
    let(:movie_id) { movie.id }
    let(:price) { Faker::Number.number(digits: 2) }
    let(:start_time) { DateTime.current }

    context "when no user" do
      it "redirects to sign_in" do
        post("/seances")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        post("/seances")
        expect(response.status).to eq(302)
      end

      it "does not create a seance record" do
        expect { post("/seances", params:) }.not_to change(Seance, :count)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        post("/seances", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        post("/seances")
        expect(response.status).to eq(302)
      end

      it "does not create a seance record" do
        expect { post("/seances", params:) }.not_to change(Seance, :count)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        post("/seances", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        post("/seances", params:)
        expect(response).to redirect_to("/movies/#{movie_id}")
      end

      it "creates seance record" do
        expect { post("/seances", params:) }.to change(Seance, :count).by(1)
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:price) { nil }

      it "doesn't create seance record" do
        expect { post("/seances", params:) }.not_to change(Seance, :count)
      end

      it "returns unsuccessful response" do
        post("/seances", params:)
        expect(response.status).to eq(422)
      end
    end

    context "when hall used" do
      before { sign_in manager }

      it "doesn't create seance record" do
        post("/seances", params:)
        expect { post("/seances", params:) }.not_to change(Seance, :count)
      end

      it "returns unsuccessful response" do
        post("/seances", params:)
        post("/seances", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET /seances/seance_id/edit" do
    let(:seance) { create :seance }
    context "when no user" do
      it "redirects to sign_in" do
        get("/seances/#{seance.id}/edit")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/seances/#{seance.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/seances/#{seance.id}/edit")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/seances/#{seance.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/seances/#{seance.id}/edit")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/seances/#{seance.id}/edit")
        expect(response).to render_template("seances/edit")
      end
    end
  end

  describe "PATCH /seances/seance_id" do
    let(:seance) { create :seance }
    let(:params) do
      {
        seance: {
          start_time:,
          price:,
          movie_id:,
          hall_id:
        }
      }
    end
    let(:movie) { create :movie }
    let(:hall) { create :hall }

    let(:hall_id) { hall.id }
    let(:movie_id) { movie.id }
    let(:price) { Faker::Number.number(digits: 2) }
    let(:start_time) { DateTime.current }

    context "when no user" do
      it "redirects to sign_in" do
        patch("/seances/#{seance.id}", params:)
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        patch("/seances/#{seance.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        patch("/seances/#{seance.id}", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        patch("/seances/#{seance.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        patch("/seances/#{seance.id}", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        patch("/seances/#{seance.id}", params:)
        expect(response).to redirect_to("/movies/#{movie_id}")
      end

      it "updates seance price" do
        expect { patch("/seances/#{seance.id}", params:) }.to change {
                                                                seance.reload.price
                                                              }.from(seance.price).to(price)
      end
      it "updates movie" do
        expect { patch("/seances/#{seance.id}", params:) }.to change {
                                                                seance.reload.movie_id
                                                              }.from(seance.movie_id).to(movie_id)
      end
      it "updates hall" do
        expect { patch("/seances/#{seance.id}", params:) }.to change {
                                                                seance.reload.hall_id
                                                              }.from(seance.hall_id).to(hall_id)
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:price) { "s" }

      it "doesn't update seance record" do
        expect { patch("/seances/#{seance.id}", params:) }.not_to(change { seance.reload.price })
      end

      it "returns unsuccessful response" do
        patch("/seances/#{seance.id}", params:)
        expect(response.status).to eq(422)
      end

      let(:price) { Faker::Number.number(digits: 2) }
      let(:start_time) { nil }

      it "doesn't update seance record" do
        expect { patch("/seances/#{seance.id}", params:) }.not_to(change { seance.reload.start_time })
      end

      it "returns unsuccessful response" do
        patch("/seances/#{seance.id}", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /seances/seance_id" do
    let(:seance) { create :seance }
    context "when no user" do
      it "redirects to sign_in" do
        delete("/seances/#{seance.id}")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        delete("/seances/#{seance.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        delete("/seances/#{seance.id}")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        delete("/seances/#{seance.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      let(:admin) { create :user, email: "testadmin@test.com", role: 2 }
      before { sign_in admin }
      it "returns redirect status" do
        delete("/seances/#{seance.id}")
        expect(response.status).to eq(302)
      end

      it "redirects to /movies/movie_id" do
        delete("/seances/#{seance.id}")
        expect(response).to redirect_to("/movies/#{seance.movie_id}")
      end

      it "destroy seance record" do
        expect { delete("/seances/#{seance.id}") }.not_to change(Seance, :count)
      end
    end
  end
end
