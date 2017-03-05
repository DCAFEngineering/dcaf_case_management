require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  before do
    @user = create :user
    sign_in @user
    @patient = create :patient
  end

  describe 'create method' do
    before do
      @call = attributes_for :call
      post :create, patient_id: @patient.id, call: @call, format: :js
    end

    it 'should create and save a new call' do
      assert_difference 'Patient.find(@patient).calls.count', 1 do
        post :create, call: @call, patient_id: @patient.id, format: :js
      end
    end

    it 'should respond success if patient is not reached' do
      call = attributes_for :call, status: 'Left voicemail'
      post :create, call: call, patient_id: @patient.id, format: :js
      assert_response :success
    end

    it 'should redirect to the edit patient path if patient is reached' do
      assert_redirected_to edit_patient_path(@patient)
    end

    it 'should render create.js.erb if patient is not reached' do
      ['Left voicemail', "Couldn't reach patient"].each do |status|
        @call[:status] = status
        post :create, call: @call, patient_id: @patient.id, format: :js
        assert_template 'calls/create'
      end
    end

    it 'should not save and flash an error if status is blank or bad' do
      [nil, 'not a real status'].each do |bad_status|
        @call[:status] = bad_status
        assert_no_difference 'Patient.find(@patient).calls.count' do
          post :create, call: @call, patient_id: @patient.id, format: :js
        end
        assert_response :bad_request
      end
    end

    it 'should log the creating user' do
      assert_equal Patient.find(@patient).calls.last.created_by, @user
    end
  end

  describe 'destroy method' do
    it 'should destroy a call' do
      call = create :call, patient: @patient, created_by: @user
      assert_difference 'Patient.find(@patient).calls.count', -1 do
        delete :destroy, id: call.id, patient_id: @patient.id, format: :js
      end
    end

    it 'should not allow user to destroy calls created by others' do
      call = create :call, patient: @patient, created_by: create(:user)
      assert_no_difference 'Patient.find(@patient).calls.count' do
        delete :destroy, id: call.id, patient_id: @patient.id, format: :js
      end
      assert_response :forbidden
    end

    it 'should not allow user to destroy old calls' do
      call = create :call, patient: @patient, created_by: @user, updated_at: Time.now - 1.day
      assert_no_difference 'Patient.find(@patient).calls.count' do
        delete :destroy, id: call.id, patient_id: @patient.id, format: :js
      end
      assert_response :forbidden
    end
  end
end
