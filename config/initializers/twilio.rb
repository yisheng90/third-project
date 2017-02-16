path = File.join(Rails.root, "config/twilio.yml")
TWILIO_CONFIG = YAML.load(File.read(path))[Rails.env] || {'sid' => 'ACe34e32dc57d22df1017262b0964f0f9f', 'from' => '15302854659', 'token' => 'cc1f3c75cdf67763fba6d7a6c98359f8'}
