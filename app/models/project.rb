class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_and_belongs_to_many :employees, class_name: 'User'

  has_many_attached :extra_files

  validates :name, :start_date, :end_date, presence: true
  validates :commercial_name, :international_no_patent, :chemical_name, :project_type, presence: true, if: :new_preperate?

  def as_json(options = {})
    super(options).tap do |hash|
      if options[:include_file_urls]
        hash[:extra_files_urls] = extra_files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
      end
      hash[:extras] = extras.map { |extra| JSON.parse(extra) } rescue extras
      hash[:employees] = employees.map { |employee| employee.as_json(only: [:id, :email, :name]) }
    end
  end
end
