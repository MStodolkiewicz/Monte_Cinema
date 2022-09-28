require 'rails_helper'

RSpec.describe "/halls", type: :request do
  let(:user) { create :user }
  let(:manager) { create :user, email: "testmanager@test.com", role: :manager }
  describe "GET /halls" do
    context "when no user" do
      it "redirects to sign_in" do
        get("/halls")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/halls")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/halls")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/halls")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/halls")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/halls")
        expect(response).to render_template("halls/index")
      end
    end
  end

  describe "GET /halls/new" do
    context "when no user" do
      it "redirects to sign_in" do
        get("/halls/new")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/halls/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/halls/new")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/halls/new")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/halls/new")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/halls/new")
        expect(response).to render_template("halls/new")
      end
    end
  end

  describe "POST /halls" do
    let(:params) do
      {
        hall: {
          name:,
          capacity:
        }
      }
    end

    let(:name) { "Sala #{Faker::Number.number(digits: 1)}" }
    let(:capacity) { Faker::Number.number(digits: 2) }

    context "when no user" do
      it "redirects to sign_in" do
        post("/halls")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        post("/halls")
        expect(response.status).to eq(302)
      end

      it "does not create a hall record" do
        expect { post("/halls", params:) }.not_to change(Hall, :count)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        post("/halls", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        post("/halls")
        expect(response.status).to eq(302)
      end

      it "does not create a hall record" do
        expect { post("/halls", params:) }.not_to change(Hall, :count)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        post("/halls", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to /halls" do
        post("/halls", params:)
        expect(response).to redirect_to("/halls")
      end

      it "creates hall record" do
        expect { post("/halls", params:) }.to change(Hall, :count).by(1)
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:capacity) { "s" }

      it "doesn't create hall record" do
        expect { post("/halls", params:) }.not_to change(Hall, :count)
      end

      it "returns unsuccessful response" do
        post("/halls", params:)
        expect(response.status).to eq(422)
      end

      let(:capacity) { Faker::Number.number(digits: 2) }
      let(:name) { nil }

      it "doesn't create hall record" do
        expect { post("/halls", params:) }.not_to change(Hall, :count)
      end

      it "returns unsuccessful response" do
        post("/halls", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET /halls/hall_id/edit" do
    let(:hall) { create :hall }
    context "when no user" do
      it "redirects to sign_in" do
        get("/halls/#{hall.id}/edit")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        get("/halls/#{hall.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        get("/halls/#{hall.id}/edit")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        get("/halls/#{hall.id}/edit")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns successful response" do
        get("/halls/#{hall.id}/edit")
        expect(response.status).to eq(200)
      end

      it "renders proper template" do
        get("/halls/#{hall.id}/edit")
        expect(response).to render_template("halls/edit")
      end
    end
  end

  describe "PATCH /halls" do
    let(:hall) { create :hall }
    let(:params) do
      {
        hall: {
          name:,
          capacity:
        }
      }
    end

    let(:name) { "Sala #{Faker::Number.number(digits: 1)}" }
    let(:capacity) { Faker::Number.number(digits: 2) }

    context "when no user" do
      it "redirects to sign_in" do
        patch("/halls/#{hall.id}", params:)
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        patch("/halls/#{hall.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        patch("/halls/#{hall.id}", params:)
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        patch("/halls/#{hall.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      before { sign_in manager }
      it "returns redirect status" do
        patch("/halls/#{hall.id}", params:)
        expect(response.status).to eq(302)
      end

      it "redirects to /halls" do
        patch("/halls/#{hall.id}", params:)
        expect(response).to redirect_to("/halls")
      end

      it "updates hall record" do
        expect { patch("/halls/#{hall.id}", params:) }.to change { hall.reload.name }.from(hall.name).to(name.to_s)
      end
    end

    context "when params invalid" do
      before { sign_in manager }
      let(:duration) { "s" }

      it "doesn't create hall record" do
        expect { patch("/halls/#{hall.id}", params:) }.not_to(change { hall.reload.name })
      end

      it "returns unsuccessful response" do
        patch("/halls/#{hall.id}", params:)
        expect(response.status).to eq(422)
      end

      let(:duration) { Faker::Number.number(digits: 2) }
      let(:name) { nil }

      it "doesn't create hall record" do
        expect { patch("/halls/#{hall.id}", params:) }.not_to(change { hall.reload.name })
      end

      it "returns unsuccessful response" do
        patch("/halls/#{hall.id}", params:)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /halls" do
    let(:hall) { create :hall }
    context "when no user" do
      it "redirects to sign_in" do
        delete("/halls/#{hall.id}")
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        delete("/halls/#{hall.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user without permission" do
      before { sign_in user }
      it "redirects to root" do
        delete("/halls/#{hall.id}")
        expect(response).to redirect_to("/")
      end

      it "returns redirect status" do
        delete("/halls/#{hall.id}")
        expect(response.status).to eq(302)
      end
    end

    context "when user with permission" do
      let(:admin) { create :user, email: "testadmin@test.com", role: 2 }
      before { sign_in admin }
      it "returns redirect status" do
        delete("/halls/#{hall.id}")
        expect(response.status).to eq(302)
      end

      it "redirects to /halls" do
        delete("/halls/#{hall.id}")
        expect(response).to redirect_to("/halls")
      end

      it "destroy hall record" do
        expect { delete("/halls/#{hall.id}") }.not_to change(Hall, :count)
      end
    end
  end
end
