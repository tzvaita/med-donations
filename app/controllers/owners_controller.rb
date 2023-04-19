class OwnersController < ApplicationController
  before_action :set_owner, only: %i[ show edit update destroy ]

  # GET /owners or /owners.json
  def index
    @owners = Owner.all
  end

  # GET /owners/1 or /owners/1.json
  def show
  end

  # GET /owners/new
  def new
    @owner = Owner.new
  end

  # GET /owners/1/edit
  def edit
  end

  # POST /owners or /owners.json
  def create
    @owner = Owner.new(owner_params)

    # respond_to do |format|
      if @owner.save
        process_paynow
      # else
      #   format.html { render :new, status: :unprocessable_entity }
      #   format.json { render json: @owner.errors, status: :unprocessable_entity }
      # end
    end
  end

  def process_paynow
    paynow = Paynow.new('15923', '862d1a52-65e6-496a-996b-7bd19b0e8dfc', "http://localhost:3000/owners/#{@owner}", "http://localhost:3000/owners/#{@owner}")

    payment = paynow.create_payment('Order Number', 'h210345m@hit.ac.zw')
    payment.add('goods', 22.76)
    response = paynow.send(payment)

    if response.success
      redirect_to response.redirect_url, allow_other_host: true
      # poll_url = response.poll_url
      # print("Poll Url: ", poll_url)
      # status = paynow.check_transaction_status(poll_url)
      # print("Payment Status: ", status.status)
    end
  end

  # PATCH/PUT /owners/1 or /owners/1.json
  def update
    respond_to do |format|
      if @owner.update(owner_params)
        format.html { redirect_to owner_url(@owner), notice: "Owner was successfully updated." }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1 or /owners/1.json
  def destroy
    @owner.destroy

    respond_to do |format|
      format.html { redirect_to owners_url, notice: "Owner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner
      @owner = Owner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def owner_params
      params.fetch(:owner, {})
    end
end
