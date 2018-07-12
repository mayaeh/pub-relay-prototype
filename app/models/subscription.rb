# frozen_string_literal: true
class Subscription < ApplicationRecord
  after_commit :reset_cache

  private

  def reset_cache
    Rails.cache.delete('subscriptions')
  end
end
