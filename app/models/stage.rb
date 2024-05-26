class Stage < ApplicationRecord
  belongs_to :project
  belongs_to :predecessor, class_name: 'Stage', optional: true
  has_one :successor, class_name: 'Stage', foreign_key: 'predecessor_id', dependent: :nullify
  has_and_belongs_to_many :performers, class_name: 'User', join_table: :performers_stages
  has_many :stage_tasks, dependent: :destroy
  has_many_attached :attached_files

  validates :name, presence: true
  validates :status, presence: true
  validate :dates_within_project_period

  private

  def dates_within_project_period
    if start_date && (start_date < project.start_date || start_date > project.end_date)
      errors.add(:start_date, "must be within the project period")
    end
    if end_date && (end_date < project.start_date || end_date > project.end_date)
      errors.add(:end_date, "must be within the project period")
    end
  end
end
