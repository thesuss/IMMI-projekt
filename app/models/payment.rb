class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true # used for branding_fee

  validates_presence_of :user, :payment_type, :status, :start_date, :expire_date
  validates_presence_of :hips_id, on: :update

  PAYMENT_TYPE_MEMBER   = 'member_fee'
  PAYMENT_TYPE_BRANDING = 'branding_fee'

  # This hash maps a HIPS order status to an SHF payment status.
  # The payment values are stored in the DB and exposed to the user.
  # (The user is paying a fee to SHF (payment).  In order to process that
  #  payment, we create a HIPS order and pass that to HIPS, which then
  #  processes that order (that is, has the user pay for the order).
  #  Note that here, "payment" refers to the SHF Payment, and "order" to
  #  the HIPS order).
  # Note that successful order payment (on the HIPS side) is represented by
  # order status 'successful'.  On the SHF side, that translates to a
  # completed payment ('paid') for the user fee (e.g. a membership fee).
  ORDER_PAYMENT_STATUS = {
    nil          => 'skapad',  # created
    'pending'    => 'avvaktan',
    'successful' => 'betald',   # paid
    'expired'    => 'utgånget',
    'awaiting_payments' => 'Väntar på betalning' # awaiting payment
  }.freeze

  validates :status, inclusion: ORDER_PAYMENT_STATUS.values

  scope :completed, -> { where(status: ORDER_PAYMENT_STATUS['successful']) }

  scope :unexpired, -> { where('expire_date >= ?', Time.zone.today ) }

  scope PAYMENT_TYPE_MEMBER.to_sym, -> { where(payment_type: PAYMENT_TYPE_MEMBER) }

  scope PAYMENT_TYPE_BRANDING.to_sym, -> { where(payment_type: PAYMENT_TYPE_BRANDING) }

  def self.order_to_payment_status(order_status)
    ORDER_PAYMENT_STATUS.fetch(order_status, 'unknown')
  end
end
