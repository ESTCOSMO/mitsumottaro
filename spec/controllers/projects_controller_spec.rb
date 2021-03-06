require 'spec_helper'

describe ProjectsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { 'name' => 'MyString' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'GET index' do
    it 'assigns active projects as @projects' do
      project = Project.create! valid_attributes
      archived = Project.create!(name: 'Archive', archived: true)
      get :index, {}, valid_session
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET archived' do
    it 'assigns archived projects as @projects' do
      project = Project.create! valid_attributes
      archived = Project.create!(name: 'Archive', archived: true)
      get :archived, {}, valid_session
      expect(assigns(:projects)).to eq([archived])
    end
  end

  describe 'GET show' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :show, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET new' do
    it 'assigns a new project as @project' do
      get :new, {}, valid_session
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :edit, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, {:project => valid_attributes}, valid_session
        }.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, {:project => valid_attributes}, valid_session
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, {:project => valid_attributes}, valid_session
        expect(response).to redirect_to(Project.last)
      end

      context 'when default template task exists, ' do
        let(:template_task){TemplateTask.new(name: 'Task', price_per_day: 40000, default_task: false)}
        let(:default_template_task){TemplateTask.new(name: 'Default Task', price_per_day: 50000, default_task: true)}
        before do
          template_task.save!
          default_template_task.save!
        end
        it 'default TemplateTask is added' do
          post :create, {:project => valid_attributes}, valid_session
          project_tasks = ProjectTask.where(project_id: Project.last.id)
          expect(project_tasks.count).to eq 1
          expect(project_tasks[0].name).to eq 'Default Task'
          expect(project_tasks[0].price_per_day).to eq 50000
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        post :create, {:project => { 'name' => 'invalid value' }}, valid_session
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        post :create, {:project => { 'name' => 'invalid value' }}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested project' do
        project = Project.create! valid_attributes
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Project).to receive(:update_attributes).with({ 'name' => 'MyString' })
        put :update, {:id => project.to_param, :project => { 'name' => 'MyString' }}, valid_session
      end

      it 'assigns the requested project as @project' do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes}, valid_session
        expect(response).to redirect_to(project)
      end
    end

    describe 'with invalid params' do
      it 'assigns the project as @project' do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        put :update, {:id => project.to_param, :project => { 'name' => 'invalid value' }}, valid_session
        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        put :update, {:id => project.to_param, :project => { 'name' => 'invalid value' }}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, {:id => project.to_param}, valid_session
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = Project.create! valid_attributes
      delete :destroy, {:id => project.to_param}, valid_session
      expect(response).to redirect_to(archived_projects_url)
    end
  end

  describe "GET 'dup_form'" do
    before do
      @project = Project.new(name: 'Sample', days_per_point: 0.5)
      @project.save!
    end
    describe 'check redirect path' do
      before{ get :dup_form, { id: @project.id } }
      subject{ response }
      it{  is_expected.to redirect_to root_url }
    end
  end

  describe 'Post archive' do
    before do
      @project = Project.create(name: 'Sample', archived: false)
    end
    describe 'check to updating project data' do
      before{ post :archive, { id: @project.id } }
      subject{ Project.find(@project.id) }

      describe '#archived' do
        subject { super().archived }
        it { is_expected.to be_truthy }
      end
    end
    describe 'check redirect path' do
      before{ post :archive, { id: @project.id } }
      subject{ response }
      it{  is_expected.to redirect_to root_url }
    end
  end

  describe 'Post active' do
    before do
      @project = Project.create(name: 'Sample', archived: true)
    end
    describe 'check to updating project data' do
      before{ post :active, { id: @project.id } }
      subject{ Project.find(@project.id) }

      describe '#archived' do
        subject { super().archived }
        it { is_expected.to be_falsey }
      end
    end
    describe 'check redirect path' do
      before{ post :active, { id: @project.id } }
      subject{ response }
      it{  is_expected.to redirect_to archived_projects_path }
    end
  end
end
