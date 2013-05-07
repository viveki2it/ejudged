require 'test_helper'

class JudgeSheetsControllerTest < ActionController::TestCase
  setup do
    @judge_sheet = judge_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:judge_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create judge_sheet" do
    assert_difference('JudgeSheet.count') do
      post :create, judge_sheet: { Name: @judge_sheet.Name }
    end

    assert_redirected_to judge_sheet_path(assigns(:judge_sheet))
  end

  test "should show judge_sheet" do
    get :show, id: @judge_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @judge_sheet
    assert_response :success
  end

  test "should update judge_sheet" do
    put :update, id: @judge_sheet, judge_sheet: { Name: @judge_sheet.Name }
    assert_redirected_to judge_sheet_path(assigns(:judge_sheet))
  end

  test "should destroy judge_sheet" do
    assert_difference('JudgeSheet.count', -1) do
      delete :destroy, id: @judge_sheet
    end

    assert_redirected_to judge_sheets_path
  end
end
