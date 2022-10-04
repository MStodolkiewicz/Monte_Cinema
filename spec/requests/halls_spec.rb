require 'rails_helper'

RSpec.describe "/halls", type: :request do
  let(:user) { create :user }
  let(:manager) { create :user, email: "testmanager@test.com", role: :manager }
  subject(:request) { get('/halls') }

  describe "GET /halls" do
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
        expect(response).to render_template("halls/index")
      end
    end
  end

  describe "GET /halls/new" do
    subject(:request) { get('/halls/new') }
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
        expect(response).to render_template("halls/new")
      end
    end
  end

  describe "POST /halls" do
    subject(:request) { post('/halls', params:) }

    let(:params) {{ hall: attributes_for(:hall, name:, capacity:) }}
    let(:name) { "Sala #{Faker::Number.number(digits: 1)}" }
    let(:capacity) { Faker::Number.number(digits: 2) }

    context "when no user" do
      before { request }
      it "redirects to sign_in" do
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns redirect status" do
        expect(response.status).to eq(302)
      end

      it "does not create a hall record" do
        expect(Hall.count).to eq(0)
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

      it "does not create a hall record" do
        expect(Hall.count).to eq(0)
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

      it "redirects to /halls" do
        expect(response).to redirect_to("/halls")
      end

      it "creates hall record" do
        expect(Hall.count).to eq(1)
      end
    end

    context "when capacity invalid" do
      before do 
        sign_in manager
        request
      end
      let(:capacity) { "NotAnInteger" }

      it "doesn't create hall record" do
        expect(Hall.count).to eq(0)
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422)
      end
    end

    context "when name invalid" do
      before do 
        sign_in manager
        request
      end
      let(:name) { nil }

      it "doesn't create hall record" do
        expect(Hall.count).to eq(0)
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422) 
      end
    end
  end

  describe "GET /halls/hall_id/edit" do
    subject(:request) { get("/halls/#{hall.id}/edit") }
    let(:hall) { create :hall }
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
        expect(response).to render_template("halls/edit")
      end
    end
  end

  describe "PATCH /halls/hall_id" do
    subject(:request) { patch("/halls/#{hall.id}", params:) }
    
    let(:hall) { create :hall }
    let(:params) {{ hall: attributes_for(:hall, name:, capacity:) }}
    let(:name) { "Sala #{Faker::Number.number(digits: 1)}" }
    let(:capacity) { Faker::Number.number(digits: 2) }

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

      it "redirects to /halls" do
        expect(response).to redirect_to("/halls")
      end

      it "updates hall record" do
        expect(Hall.where(id: hall.id).pluck(:name)).to eq(["#{name}"])
      end
    end

    context "when capacity invalid" do
      before do 
        sign_in manager
        request
      end
      let(:capacity) { "NotAnInteger" }

      it "doesn't update hall record" do
        expect(Hall.where(id: hall.id).pluck(:name)).not_to eq(["#{name}"])
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422)
      end
    end

    context "when name invalid" do
      before do 
        sign_in manager
        request
      end
      let(:name) { nil }

      it "doesn't update hall record" do
        expect(Hall.where(id: hall.id).pluck(:name)).not_to eq(["#{name}"])
      end

      it "returns unsuccessful response" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /halls/hall_id" do
    subject(:request) {  delete("/halls/#{hall.id}") }
    let(:hall) { create :hall }
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

      it "redirects to /halls" do
        expect(response).to redirect_to("/halls")
      end

      it "destroy hall record" do
        expect(Hall.where(id: hall.id).count).to eq(0)
      end
    end
  end
end
