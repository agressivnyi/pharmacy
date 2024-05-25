class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'

  has_many_attached :extra_files

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def as_json(options = {})
    super(options).tap do |hash|
      if options[:include_file_urls]
        hash[:extra_files_urls] = extra_files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
      end
      hash[:extras] = extras.map { |extra| JSON.parse(extra) } rescue extras
    end
  end
end
