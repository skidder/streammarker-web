# Relays controller
class RelaysController < ApplicationController
  before_action :signed_in_user
  before_action :set_relay, only: [:show, :edit, :destroy, :update]
  before_action :authorize_user, only: [:show, :edit, :destroy, :update]

  # GET /relays/new
  def new
    @relay = Relay.new
  end

  # POST /relays
  # POST /relays.json
  def create
    @relay = Relay.new(relay_params)
    @relay.user = current_user

    respond_to do |format|
      if @relay.save
        put_relay_dynamodb_record(@relay)
        format.html do
          redirect_to @relay, notice: 'Relay was created successfully.'
        end
        format.json do
          render action: 'show', status: :created, location: @relay
        end
      else
        format.html { render action: 'new' }
        format.json do
          render json: @relay.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /relays/1
  # PATCH/PUT /relays/1.json
  def update
    respond_to do |format|
      if @relay.update(relay_params)
        put_relay_dynamodb_record(@relay)
        format.html do
          redirect_to @relay, notice: 'Relay was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @relay.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /relays/1
  # DELETE /relays/1.json
  def destroy
    @relay.destroy
    respond_to do |format|
      delete_relay_dynamodb_record(@relay)
      format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end

  private

  def put_relay_dynamodb_record(relay)
    return unless Rails.env.production?
    resp = dynamo_client.put_item(
      table_name: 'relays',
      item: {
        'id' => relay.uuid,
        'account_id' => relay.user.account_id,
        'name' => relay.name,
        'state' => 'active'
      }
    )
  end

  def delete_relay_dynamodb_record(relay)
    return unless Rails.env.production?
    resp = dynamo_client.delete_item(
      table_name: 'relays',
      key: {
        'id' => relay.uuid
      }
    )
  end

  def dynamo_client
    Aws::DynamoDB::Client.new
  end

  def set_relay
    @relay = Relay.find(params[:id])
  end

  def authorize_user
    unless @relay.user == current_user
      flash[:error] = 'You must be logged in to access this section'
      redirect_to root_url # halts request cycle
    end
  end

  def relay_params
    params.require(:relay).permit(:name,
                                  :uuid)
  end
end
