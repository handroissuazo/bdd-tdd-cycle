require 'spec_helper'

RSpec.describe MoviesController, type: :controller do

  describe 'add a director' do
    before :each do
      @m=double(Movie, :title => "Alien", :director => "director", :id => "1")
      Movie.stub(:find).with("1").and_return(@m)
    end

    it 'should call update attributes and redirect' do
      @m.stub(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end

  describe 'create and remove' do
    it 'should create a movie' do
      @new_m = double(Movie, :title => "Alien", :director => "", :id => "2")

      MoviesController.stub(:create).and_return(@new_m)
      post :create, {:movies => @new_m}
      response.should redirect_to movies_path
    end

    it 'should remove a movie by using destroy' do
      m = double(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub(:find).with("10").and_return(m)
      m.stub(:destroy).and_return("yes")
      delete :destroy, {:id => "10"}
      response.should redirect_to movies_path
    end
  end

  describe 'happy path' do
    before :each do
      @m = double(Movie, :title => "Alien", :director => "Ridley", :id => "1")
      @m1 = double(Movie, :title => "Alien", :director => "Ridley", :id => "2")
      @m2 = double(Movie, :title => "Star Wars", :director => "Lucas", :id => "3")
      Movie.stub(:find).with("1").and_return(@m)
    end

    it 'should go to home page' do
    	Movie.stub_chain(:where, :all).and_return(@m)
        get :index
        response.should render_template('index')
        assigns(:movies).should == @m
    end

    it 'should sort movies by release date' do
    	Movie.stub_chain(:where, :all, :order).and_return([@m1, @m2])
    	get :index, :sort => 'release_date'
    end

    it 'should sort movies by title' do
    	Movie.stub_chain(:where, :all).and_return(@m)
    	get :index, :sort => 'title'
    end

    it 'should render detail page' do
  		get :show, :id => "1"
  		response.should render_template('show')
  		assigns(:movie).should == @m
    end

    it 'should go to edit page' do
    	get :edit, :id => "1"
    	assigns(:movie).should == @m
    end

    it 'should make routes for movies with the same director' do
      { :get => findWithSameDirector_movie_path(1) }.
      should route_to(:controller => "movies", :action => "findWithSameDirector", :id => "1")
    end

    it 'should render findWithSameDirector page and show similar movies' do
      Movie.stub_chain(:where, :all).and_return(@m)
      get :findWithSameDirector, :id => "1"
      response.should render_template('findWithSameDirector')
      assigns(:movies).should == @m
    end

    it 'should show home page if director is empty' do
      @m_no_dir = double(Movie, :title => "Aliens", :director => "", :id => "2")
      Movie.stub(:find).with("2").and_return(@m_no_dir)
      get :findWithSameDirector, :id => "2"
      response.should redirect_to movies_path
    end
  end

  describe 'sad path' do
    before :each do
      m = double(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub(:find).with("1").and_return(m)
    end

    it 'should make routes for similar movies' do
      { :get => findWithSameDirector_movie_path(1) }.
      should route_to(:controller => "movies", :action => "findWithSameDirector", :id => "1")
    end
  end

end
