class PaymentsController < ApplicationController
  before_action :set_bill
  after_action :verify_authorized, except: [:new, :create]


  skip_before_action :authenticate_user!, only: [:create]


  def create
    customer = Stripe::Customer.create(

      source: params[:payment][:stripe_token],
      email:  params[:payment][:stripe_email]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @bill.check_orders.cents,
      description:  "Thank you for paying",
      currency:     :eur
    )

    @bill.orders.each do |order|
      if order.status == "ticked"
        order.status = "paid"
        order.save!
      end
    end
    @bill.update_balance
    if @bill.balance == 0
      @bill.update(status: "paid")
      redirect_to goodbye_path
    else
      redirect_to bill_path(@bill)
    end

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to bill_path(@bill)
  end

private

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end
end

