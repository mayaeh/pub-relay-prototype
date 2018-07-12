# frozen_string_literal: true
class Block < ApplicationRecord
  after_commit :reset_cache

  private

  def reset_cache
    Rails.cache.delete("block:#{domain}")
  end
end
