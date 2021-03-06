# frozen_string_literal: true
class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type

  has_one :damage, dependent: :destroy # zero or one damages, depending on incidental_type
  has_one :item, through: :rental
  has_one :financial_transaction, as: :transactable
  has_many :notes, as: :noteable
  has_many :documents, as: :documentable, dependent: :destroy

  accepts_nested_attributes_for :notes, reject_if: proc { |attributes| attributes.all? { |_, v| v.blank? } }
  accepts_nested_attributes_for :financial_transaction
  accepts_nested_attributes_for :documents, reject_if: proc { |attributes|
    attributes[:description].blank?
  }

  validates_associated :rental, :incidental_type, :notes, :documents

  validates :rental, :notes, presence: true
  validates :incidental_type, uniqueness: { scope: :rental, message: 'should happen once per rental' }, presence: true
end
