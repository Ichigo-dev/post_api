require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:one_post) { Post.create(title: 'memo1') }
  let(:params) { { post: { title: 'hoge' } } }

  context 'GET: /posts' do
    before do
      FactoryBot.create_list(:post, 10)
      get '/api/v1/posts'
      @json = JSON.parse(response.body)
    end

    it 'status == 200' do
      expect(response.status).to eq(200)
    end

    it 'can get all post' do
      expect(@json['data'].length).to eq(10)
    end
  end

  context 'GET: /posts/:id' do
    before do
      get "/api/v1/posts/#{one_post.id}"
      @json = JSON.parse(response.body)
    end

    it 'status == 200' do
      expect(response.status).to eq(200)
    end

    it 'can get the post' do
      expect(@json['data']['title']).to eq('memo1')
    end
  end

  context 'POST: /posts/create' do
    before do
      post '/api/v1/posts', params: params
    end

    it 'status == 200' do
      expect(response.status).to eq(200)
    end

    before do
      @post = Post.first
    end

    it 'can create the post' do
      expect(@post.title).to eq(params[:post][:title])
    end
  end

  context 'PUT: api/v1/posts/:id' do
    before do
      put "/api/v1/posts/#{one_post.id}", params: params
    end

    it 'status == 200' do
      expect(response.status).to eq(200)
    end

    before do
      @updated_post = Post.first
    end

    it 'can update the post' do
      expect(@updated_post.title).to eq(params[:post][:title])
    end
  end

  context 'DELETE: api/v1/posts/:id' do
    before do
      delete "/api/v1/posts/#{one_post.id}"
    end

    it 'status == 200' do
      expect(response.status).to eq(200)
    end

    it 'can delete the post' do
      expect(Post.all.count).to be_zero
    end
  end
end
