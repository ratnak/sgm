require 'test_helper'
require 'balanced'
#Balanced.configure(Simplegym::Application.config.balanced_api_key)

class Payments < ActiveSupport::TestCase
  test "payment config" do
    assert Simplegym::Application.config.balanced_api_key == "ak-test-tmHMthYSz4WzEvgD9WJN4EcCfd5sR5df"
    assert Simplegym::Application.config.marketplace_uri == "/v1/marketplaces/TEST-MP14FzRFKnLCfCLZnKuVu5C0"
  end

  test "create bank account" do
    Balanced.configure(Simplegym::Application.config.balanced_api_key)
    bank_account = Balanced::BankAccount.new(
        :account_number => '9900000001',
        :name => 'Johann Bernoulli',
        :routing_number => '121000358',
        :type => 'checking'
    ).save

    bank_account2 = Balanced::BankAccount.find(bank_account.uri)
    assert bank_account2.name == bank_account.name

    bank_account2.destroy
  end

  test "find bank account" do

    bank_account1 = Balanced::BankAccount.find("/v1/bank_accounts/BA4lMyLecWcIfLNDdhTZkLuo")
    assert bank_account1.name == 'Johann Bernoulli'
    #bank_account1.destroy

    #bank_account2 = Balanced::BankAccount.find("/v1/bank_accounts/BA49RpfVhdcGMDYpdSLN91Qy")
    #bank_account2.destroy

    #bank_account3 = Balanced::BankAccount.find("/v1/bank_accounts/BA7AUibyeuKF60o43jz0F4ls")
    #bank_account3.destroy

    #bank_account4 = Balanced::BankAccount.find("/v1/bank_accounts/BA1X7zSvlHYrXdB2M1Wy2oWG")
    #bank_account4.destroy
  end

  test "pay by credit card" do

    customer = Balanced::Customer.new(
        :name           => "Bill",
        :email          => "bill@bill.com",
        :business_name  => "Bill Inc.",
        :ssn_last4      => "1234",
        :address => {
            :line1 => "1234 1st Street",
            :city  => "San Francisco",
            :state => "CA"
        }
    )
    customer.save

    customer2 = Balanced::Customer.find(customer.uri)
    assert customer2.name == customer.name


    card = Balanced::Card.new(
        :card_number => '5105105105105100',
        :expiration_month => '12',
        :expiration_year => '2020',
        :security_code => '123'
    )

    card.save

    response = customer2.add_card( card.uri )
    charge_amount = 50
    customer2.debit(:amount => (charge_amount * 100))
    fees = (charge_amount * 0.029) + 0.30
    credit_amount = (charge_amount - fees)
    bank_account1 = Balanced::BankAccount.find("/v1/bank_accounts/BA4lMyLecWcIfLNDdhTZkLuo")
    bank_account1.credit(:amount => (credit_amount * 100))

  end

  test "pay by bank transfer" do

    customer = Balanced::Customer.new(
        :name           => "Bill Test",
        :email          => "billtest@bill.com",
        :business_name  => "Bill Inc.",
        :ssn_last4      => "4321",
        :address => {
            :line1 => "1234 1st Street",
            :city  => "San Francisco",
            :state => "CA"
        }
    )

    customer.save
    customer2 = Balanced::Customer.find(customer.uri)
    assert customer2.name == customer.name

    bank_account = Balanced::BankAccount.new(
        :account_number => '9900000002',
        :name => 'Bill Test',
        :routing_number => '121000358',
        :type => 'checking'
    ).save

    customer.add_bank_account( bank_account );

    verification = bank_account.verify
    verification2 = Balanced::Verification.find( verification.uri )
    assert verification2.uri == verification.uri

    verification2.amount_1 = 1
    verification2.amount_2 = 1
    verification2.save

    charge_amount = 100
    debit = customer2.debit(:amount => (charge_amount * 100))
    assert debit.status == "succeeded"

    fees = (charge_amount * 0.029) + 0.30
    credit_amount = (charge_amount - fees)
    bank_account1 = Balanced::BankAccount.find("/v1/bank_accounts/BA4lMyLecWcIfLNDdhTZkLuo")
    credit = bank_account1.credit(:amount => (credit_amount * 100))
    assert credit.status == "paid"

  end


end