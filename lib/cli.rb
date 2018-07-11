require 'thor'

module PubRelay
  class CLI < Thor
    desc 'block DOMAIN', 'Block ingress and egress to DOMAIN'
    def block(domain)
      ::Block.create!(domain: domain)
      ::Subscription.where(domain: domain).delete_all
      say 'OK', :green
    end

    desc 'unblock DOMAIN', 'Remove block for DOMAIN'
    def unblock(domain)
      ::Block.where(domain: domain).delete_all
      say 'OK', :green
    end
  end
end
