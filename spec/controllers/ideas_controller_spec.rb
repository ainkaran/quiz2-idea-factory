require 'rails_helper'

RSpec.describe IdeasController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:idea)   { FactoryGirl.create(:idea, user: user) }
  let(:idea_1) { FactoryGirl.create(:idea) }

  describe "#new" do
    context "with no signed in user" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "with signed in user" do
      before do
        request.session[:user_id] = user.id
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns a idea instance variable to a new Idea" do
        get :new
        expect(assigns(:idea)).to be_a_new Idea
      end
    end
  end
=begin
  describe "#create" do
    context "user not signed in" do
      it "redirects to sign in page" do
        attributes = FactoryGirl.attributes_for(:idea).merge(user_id: user.id)
        post :create, params: { idea: attributes }
        expect(response).to redirect_to new_session_path
      end
    end

    context "user signed in" do
      before { request.session[:user_id] = user.id }

      context "with valid parameters" do
        def valid_request
          attributes = FactoryGirl.attributes_for(:idea).merge(user_id: user.id)
          post :create, params: { idea: attributes }
        end

        it "creates a new idea in the database" do
          expect { valid_request }.to change { Idea.count }.by(1)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "redirect to idea show page" do
          valid_request
          expect(response).to redirect_to(idea_path(Idea.last))
        end

        it "associates the created idea to the user" do
          valid_request
          expect(Idea.last.user).to eq(user)
        end

        # it "associates the created idea to the user" do
        #   valid_request
        #   expect(Idea.last.user).to eq(user)
        # end
      end

      context "with invalid parameters" do
        def invalid_request
          attributes = FactoryGirl.attributes_for(:idea).merge(title: nil, user_id: user.id)
          post :create, params: { idea: attributes }
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Idea.count }.by(0)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end
  end
=end

  describe '#create' do
    def valid_post
      post :create, params: { idea: FactoryGirl.attributes_for(:idea) }
    end

    context 'with no user signed in' do
      it 'redirects to the sign in page' do
        valid_post
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with signed in user' do
      before do
        # request.session[:user_id] = user.id
        login(user)
      end

      context 'with valid attributes' do
        it 'creates a new idea in the database' do
          count_before = Idea.count
          valid_post
          count_after = Idea.count

          expect(count_after).to eq(count_before + 1)
        end

        it 'redirects to the idea show page' do
          valid_post
          expect(response).to redirect_to(idea_path(Idea.last))
        end

        it 'associates the created idea with the signed in user' do
          valid_post
          expect(Idea.last.user).to eq(user)
        end
      end

      context 'with invalid attributes' do
        before do
          idea = FactoryGirl.attributes_for(:idea)
          idea[:title] = ''
          post :create, params: { idea: idea }
        end

        it 'doesn\'t create a idea in the database' do
          expect(Idea.count).to eq(0)
        end

        it 'renders new template' do
          expect(response).to render_template(:new)
        end
      end
    end
  end

end
