require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                completed: Time.zone.now + 5.days
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do

      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed: nil,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed).must_equal task_hash[:task][:completed]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id)
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path(-1)
      must_respond_with :redirect
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    before do
      @task_hash = {
        task: {
          name: task.name,
          description: "updated task description",
          id: task.id,
          completed: task.completed
        },
      }     
    end
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      patch task_path(task.id), params: @task_hash

      updated_task = Task.find_by(name: @task_hash[:task][:name])
      expect(updated_task.description).must_equal @task_hash[:task][:description]
      expect(updated_task.completed).must_equal @task_hash[:task][:completed]

      must_respond_with :redirect
      must_redirect_to task_path(updated_task.id)
    end

    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1), params: @task_hash
      must_respond_with :redirect
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    it "will remove a task" do
      task = Task.create
      
      expect {
        delete task_path(task.id)
      }.must_change "Task.count", -1

      assert_nil Task.find_by(id: task.id)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "redirects if given an invalid id" do
      delete task_path(-1)
      must_respond_with :redirect
    end
  end

  # Complete for Wave 4
  describe "toggle_complete" do
    it "can mark a task as completed" do
      task = Task.create
      assert_nil task.completed
      patch complete_task_path(task.id)

      task = Task.find(task.id)
      expect(task.completed).must_be_instance_of ActiveSupport::TimeWithZone
      must_respond_with :redirect
    end

    it "can unmark a task" do
      task = Task.create(completed: Time.now)
      expect(task.completed).must_be_instance_of ActiveSupport::TimeWithZone
      
      patch complete_task_path(task.id)
      
      task = Task.find(task.id)
      assert_nil task.completed
      
      must_respond_with :redirect
    end

    it "redirects for an invalid id" do
      patch complete_task_path(-1)
      must_respond_with :redirect
    end
  end
end
