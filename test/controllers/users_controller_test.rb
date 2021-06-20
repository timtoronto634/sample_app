require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:michael)
    @other_user = users(:archer)
  end


  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end


  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should change user naem" do
    log_in_as(@user)
    tmp_name = @user.name
    patch user_path(@user), params: { user: {name: "hello"}}
    # debugger
    assert_not @user.reload.name == tmp_name
  end
  

  test "should not allow the admin attribute to be edited via the web " do 
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { name: "hello",
                                                    password: "password",
                                                    password_confirmation: "password", 
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect edit when logged in as another user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in a as another user " do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
