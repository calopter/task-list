class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find_by(id: params[:id])
    redirect_to task_path unless @task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    
    if @task.save
      redirect_to task_path(@task.id)
      return
    else
      render :new
      return
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    redirect_to tasks_path unless @task
  end

  def update
    task = Task.find_by(id: params[:id])
    return redirect_to tasks_path unless task
    
    task.update(task_params)
    redirect_to task_path(task.id)
  end

  def destroy
    task = Task.find_by(id: params[:id])
    return redirect_to tasks_path unless task
    task.destroy
    redirect_to tasks_path
  end

  def complete
    task = Task.find_by(id: params[:id])
    return redirect_to tasks_path unless task

    if task.completed
      task.completed = nil
    else
      task.completed = Time.zone.now
    end
    
    task.save

    return redirect_to tasks_path
  end

  private

  def task_params
    return params.require(:task).permit(:name, :description)
  end
end
