Stripe.api_key = Rails.application.credentials.dig(:stripe, :sk)
STRIPE_SUPPORTED_COUNTRIES = ['US', 'KES'].freeze