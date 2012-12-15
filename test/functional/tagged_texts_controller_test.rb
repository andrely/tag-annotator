require 'test_helper'

class TaggedTextsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tagged_texts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #test "should create tagged_text" do
  #  assert_difference('TaggedText.count') do
  #    post :create, :tagged_text => { }
  #  end
  #
  #  assert_redirected_to tagged_text_path(assigns(:tagged_text))
  #end

  #test "should show tagged_text" do
  #  get :show, :id => tagged_texts(:one).id
  #  assert_response :success
  #end

  test "should get edit" do
    get :edit, :id => tagged_texts(:one).id
    assert_response :success
  end

  test "should update tagged_text" do
    put :update, :id => tagged_texts(:one).id, :tagged_text => { }
    assert_redirected_to tagged_text_path(assigns(:tagged_text))
  end

  test "should destroy tagged_text" do
    assert_difference('TaggedText.count', -1) do
      delete :destroy, :id => tagged_texts(:one).id
    end

    assert_redirected_to tagged_texts_path
  end
end
