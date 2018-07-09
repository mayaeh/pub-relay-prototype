class Actor
  mattr_accessor :key
  @@key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('config', 'actor.pem')))
end
