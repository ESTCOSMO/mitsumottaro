class TemplateTasksController < ApplicationController
  def index
    @template_tasks = TemplateTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_tasks }
    end
  end

  # GET /template_tasks/new
  # GET /template_tasks/new.json
  def new
    @template_task = TemplateTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template_task }
    end
  end

  # GET /template_tasks/1/edit
  def edit
    @template_task = TemplateTask.find(params[:id])
  end

  # POST /template_tasks
  # POST /template_tasks.json
  def create
    @template_task = TemplateTask.new(permitted_params_for_template_task)

    respond_to do |format|
      if @template_task.save
        format.html { redirect_to template_tasks_path, notice: 'TemplateTask was successfully created.' }
        format.json { render json: @template_task, status: :created, location: @template_task }
      else
        format.html { render action: "new" }
        format.json { render json: @template_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /template_tasks/1
  # PUT /template_tasks/1.json
  def update
    @template_task = TemplateTask.find(params[:id])

    respond_to do |format|
      if @template_task.update_attributes(permitted_params_for_template_task)
        format.html { redirect_to template_tasks_path, notice: 'TemplateTask was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @template_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_tasks/1
  # DELETE /template_tasks/1.json
  def destroy
    @template_task = TemplateTask.find(params[:id])
    @template_task.destroy

    respond_to do |format|
      format.html { redirect_to template_tasks_url }
      format.json { head :no_content }
    end
  end

  private
  def permitted_params_for_template_task
    params.require(:template_task).permit(:name, :price_per_day)
  end
end
