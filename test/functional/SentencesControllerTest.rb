require 'test_helper'

class SentencesControllerTest < ActionController:TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "add word should redirect" do
    post :add_word, {:id => sentences(:one).id, :word_id => words(:one).id,
                     :word_string => 'foo', :obt_word_string => 'foo'}
    assert_redirected_to :action => :show
  end

  test "delete word should redirect" do
    post :delete_word, {:id => sentences(:one).id, :word_id => words(:one).id}
    assert_redirected_to :action => :show
  end
end