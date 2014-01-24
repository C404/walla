require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  setup do
    @tweet = tweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tweet" do
    assert_difference('Tweet.count') do
      post :create, tweet: { agent_account: @tweet.agent_account, answered_url: @tweet.answered_url, bitly: @tweet.bitly, chatter_id: @tweet.chatter_id, customer_account: @tweet.customer_account, customer_ip: @tweet.customer_ip, customer_msg: @tweet.customer_msg, msg_url: @tweet.msg_url, service_page: @tweet.service_page }
    end

    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should show tweet" do
    get :show, id: @tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tweet
    assert_response :success
  end

  test "should update tweet" do
    patch :update, id: @tweet, tweet: { agent_account: @tweet.agent_account, answered_url: @tweet.answered_url, bitly: @tweet.bitly, chatter_id: @tweet.chatter_id, customer_account: @tweet.customer_account, customer_ip: @tweet.customer_ip, customer_msg: @tweet.customer_msg, msg_url: @tweet.msg_url, service_page: @tweet.service_page }
    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should destroy tweet" do
    assert_difference('Tweet.count', -1) do
      delete :destroy, id: @tweet
    end

    assert_redirected_to tweets_path
  end
end
