require 'rails_helper'

RSpec.describe "/movies", type: :request do
  let(:user) { create :user }
  let(:manager) { create :user, email: "testmanager@test.com", role: :manager }
  describe "GET /movies" do
    subject(:request) { get movies_url }

    before { request }

    it "returns successful response" do
      expect(response).to be_successful
    end

    it "renders proper template" do
      expect(response).to render_template("movies/index")
    end
  end

  describe "GET /movies/movie_id" do
    let(:movie) { create :movie }
    it "returns successful response" do
      get("/movies/#{movie.id}")
      expect(response.status).to eq(200)
    end

    it "renders proper template" do
      get("/movies/#{movie.id}")
      expect(response).to render_template("movies/show")
    end
  end

  describe "GET /movies/new" do
    context "when no user" do
      it "redirects to sign_in" do
        get("/movies/new")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/movies/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/movies/new")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/movies/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/movies/new")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/movies/new")
        expect(response).to render_template("movies/new")
      end
    end
  end

  describe "POST /movies" do
    let(:params) do
      {
        movie: {
          name:,
          description: Faker::Movie.quote,
          duration:
        }
      }
    end

    let(:name) { Faker::Movie.title }
    let(:duration) { 95 }

    context "when no user" do
      it "redirects to sign_in" do
        post("/movies")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        post("/movies")
        expect(response.status).to eq(302)
      end

      it "does not create a movie record" do
        expect { post("/movies", params:) }.not_to change(Movie, :count)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        post("/movies", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        post("/movies")
        expect(response.status).to eq(302)
      end

      it "does not create a movie record" do
        expect { post("/movies", params:) }.not_to change(Movie, :count)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        post("/movies", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to movie/movie_id" do
        post("/movies", params:)
        expect(response).to redirect_to action: :show, id: assigns(:movie).id
      end

      it "creates movie record" do
        expect { post("/movies", params:) }.to change(Movie, :count).by(1)
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:duration) { "s" }

      it "doesn't create movie record" do
        expect { post("/movies", params:) }.not_to change(Movie, :count)
      end

      it "returns unsuccessful response" do
        post("/movies", params:)
        expect(response.status).to eq(422)
      end

      let(:duration) { 60 }
      let(:name) { nil }

      it "doesn't create movie record" do
        expect { post("/movies", params:) }.not_to change(Movie, :count)
      end

      it "returns unsuccessful response" do
        post("/movies", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET /movies/movie_id/edit" do
    let(:movie) { create :movie }
    context "when no user" do
      it "redirects to sign_in" do
        get("/movies/#{movie.id}/edit")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/movies/#{movie.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/movies/#{movie.id}/edit")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/movies/#{movie.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/movies/#{movie.id}/edit")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/movies/#{movie.id}/edit")
        expect(response).to render_template("movies/edit")
      end
    end
  end

  describe "PATCH /movies" do
    let(:movie) { create :movie }
    let(:params) do
      {
        movie: {
          name:,
          description: Faker::Movie.quote,
          duration:
        }
      }
    end

    let(:name) { Faker::Movie.title }
    let(:duration) { 120 }

    context "when no user" do
      it "redirects to sign_in" do
        patch("/movies/#{movie.id}", params:)
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        patch("/movies/#{movie.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        patch("/movies/#{movie.id}", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        patch("/movies/#{movie.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        patch("/movies/#{movie.id}", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to movie/movie_id" do
        patch("/movies/#{movie.id}", params:)
        expect(response).to redirect_to action: :show, id: assigns(:movie).id
      end

      it "updates movie record" do
        expect { patch("/movies/#{movie.id}", params:) }.to change { movie.reload.name }.from(movie.name).to("#{name}")
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:duration) { "s" }

      it "doesn't create movie record" do
        expect { patch("/movies/#{movie.id}", params:) }.not_to(change { movie.reload.name })
      end

      it "returns unsuccessful response" do
        patch("/movies/#{movie.id}", params:)
        expect(response.status).to eq(422)
      end

      let(:duration) { 60 }
      let(:name) { nil }

      it "doesn't create movie record" do
        expect { patch("/movies/#{movie.id}", params:) }.not_to(change { movie.reload.name })
      end

      it "returns unsuccessful response" do
        patch("/movies/#{movie.id}", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /movies" do
    let(:movie) { create :movie }
    context "when no user" do
      it "redirects to sign_in" do
        delete("/movies/#{movie.id}")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        delete("/movies/#{movie.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        delete("/movies/#{movie.id}")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        delete("/movies/#{movie.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      let(:admin) { create :user, email: "testadmin@test.com", role: 2 }
      before { sign_in admin }
      it "returns redirect status" do
        delete("/movies/#{movie.id}")
        expect(response.status).to eq(302)
      end

      it "redirects to /movies" do
        delete("/movies/#{movie.id}")
        expect(response).to redirect_to("/movies")
      end

      it "destroy movie record" do
        expect { delete("/movies/#{movie.id}") }.not_to change(Movie, :count)
      end
    end
  end
end
