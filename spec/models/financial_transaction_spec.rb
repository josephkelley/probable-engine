# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  describe 'testing initial financial transaction params' do
    it 'creates a valid financial transaction from a rental' do
      expect do
        expect(build(:financial_transaction, :with_rental)).to be_valid
      end.to change { FinancialTransaction.count }.by(1)
    end

    it 'does not create a financial transaction from an invalid rental' do
      expect { create :invalid_rental }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create a financial transaction without first creating a rental' do
      expect { create :financial_transaction, rental: nil }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'creates a financial transaction via post hook from creating a Rental' do
      rent = create :rental
      transaction = FinancialTransaction.first
      polymorphism_trans = rent.financial_transaction

      expect(rent).to eq(transaction.rental)
      expect(transaction).to eq(polymorphism_trans)
      expect(rent).to eq(polymorphism_trans.rental)

      base_fee = rent.item_type.base_fee
      daily_fee = rent.item_type.fee_per_day * rent.duration

      expect(transaction.initial_amount).to eq(base_fee + daily_fee)
    end

    it 'is invalid without an initial_amount' do
      expect(build(:financial_transaction, :with_rental, initial_amount: nil)).not_to be_valid
    end

    it 'is invalid without an adjustment' do
      expect(build(:financial_transaction, :with_rental, adjustment: nil)).not_to be_valid
    end

    it 'defaults to 0 when initial_amount is not specified' do
      fc = build(:financial_transaction, :with_rental)
      expect(fc.initial_amount).to eq(1)
    end

    it 'sums up the values correctly' do
      fc = build(:financial_transaction, :with_rental)
      expect(fc.value).to eq(fc.initial_amount + fc.adjustment)
    end

    it 'zeros the balance correctly' do
      fc = build(:financial_transaction, :with_rental)
      fc.update initial_amount: 999, adjustment: 333

      expect(fc.value).not_to eq(0)

      fc.zero_balance

      expect(fc.value).to eq(0)
    end

    it 'defaults to 0 when adjustment is not specified' do
      fc = build(:financial_transaction, :with_rental)
      expect(fc.adjustment).to eq(0)
    end
  end

  describe 'creating successive financial transactions' do
    it 'creates financial transaction after creating an incurred incidental' do
      rental = create :rental
      rental_trans = rental.financial_transaction
      incidental = create :incurred_incidental, rental: rental
      incidental_trans = incidental.financial_transaction

      expect(incidental_trans).to be_valid
      expect(incidental).to eq(incidental_trans.transactable)
      expect(rental).to eq(incidental_trans.rental)

      expect(incidental_trans.initial_amount).to eq(incidental.amount)
    end
  end
end
