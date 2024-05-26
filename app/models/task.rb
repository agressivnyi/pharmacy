class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :performer, class_name: 'User', optional: true
  belongs_to :parent_task, class_name: 'Task', optional: true
  has_many :subtasks, class_name: 'Task', foreign_key: 'parent_task_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :attached_files

  validates :name, presence: true
  validates :status, presence: true
  validate :dates_within_stage_period
  validate :parent_task_not_completed, if: :parent_task_id?

  private

  def dates_within_stage_period
    if start_date && (start_date < stage.start_date || start_date > stage.end_date)
      errors.add(:start_date, "must be within the stage period")
    end
    if end_date && (end_date < stage.start_date || end_date > stage.end_date)
      errors.add(:end_date, "must be within the stage period")
    end
  end

  def parent_task_not_completed
    if parent_task && parent_task.status == 'Completed'
      errors.add(:parent_task_id, "cannot add a subtask to a completed task")
    end
  end
end
