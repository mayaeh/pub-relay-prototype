require 'thor'

module PubRelay
  class CLI < Thor
    desc 'list', 'List all subscribed servers'
    def list
      ::Subscription.pluck(:domain).each do |domain|
        say domain
      end
    end

    desc 'block DOMAIN', 'Block ingress and egress to DOMAIN'
    def block(domain)
      ::Block.create!(domain: domain)
      ::Subscription.where(domain: domain).destroy_all
      say 'OK', :green
    end

    desc 'unblock DOMAIN', 'Remove block for DOMAIN'
    def unblock(domain)
      ::Block.where(domain: domain).destroy_all
      say 'OK', :green
    end
  end
end
