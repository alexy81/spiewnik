require 'test_helper'

class PiosenkasControllerTest < ActionController::TestCase
  setup do
    @piosenka = piosenkas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:piosenkas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create piosenka" do
    assert_difference('Piosenka.count') do
      post :create, piosenka: { akordy: @piosenka.akordy, obrazek: @piosenka.obrazek, tekst: @piosenka.tekst, tytul: @piosenka.tytul, wykonawca: @piosenka.wykonawca }
    end

    assert_redirected_to piosenka_path(assigns(:piosenka))
  end

  test "should show piosenka" do
    get :show, id: @piosenka
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @piosenka
    assert_response :success
  end

  test "should update piosenka" do
    patch :update, id: @piosenka, piosenka: { akordy: @piosenka.akordy, obrazek: @piosenka.obrazek, tekst: @piosenka.tekst, tytul: @piosenka.tytul, wykonawca: @piosenka.wykonawca }
    assert_redirected_to piosenka_path(assigns(:piosenka))
  end

  test "should destroy piosenka" do
    assert_difference('Piosenka.count', -1) do
      delete :destroy, id: @piosenka
    end

    assert_redirected_to piosenkas_path
  end
end
