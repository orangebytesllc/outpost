class PushSubscriptionsController < ApplicationController
  # POST /push_subscriptions
  # Creates or updates a push subscription for the current user
  def create
    subscription = Current.user.push_subscriptions.find_or_initialize_by(
      endpoint: subscription_params[:endpoint]
    )

    subscription.assign_attributes(
      p256dh: subscription_params[:p256dh],
      auth: subscription_params[:auth]
    )

    if subscription.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  # DELETE /push_subscriptions
  # Removes a push subscription
  def destroy
    subscription = Current.user.push_subscriptions.find_by(
      endpoint: params[:endpoint]
    )

    subscription&.destroy
    head :ok
  end

  # GET /push_subscriptions/vapid_public_key
  # Returns the VAPID public key for the client to use when subscribing
  def vapid_public_key
    if PushSubscription.configured?
      render json: { vapid_public_key: PushSubscription.vapid_public_key }
    else
      render json: { vapid_public_key: nil }, status: :service_unavailable
    end
  end

  private

  def subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth)
  end
end
