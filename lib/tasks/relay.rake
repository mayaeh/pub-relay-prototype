desc 'Generate actor signature key'
task :keygen do
  key = OpenSSL::PKey::RSA.new(2048)
  File.write(Rails.root.join('config', 'actor.pem'), key.to_pem)
end
