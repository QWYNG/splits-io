class RunValidator < ActiveModel::Validator
  def validate(record)
    validate_default_timing(record)
    validate_video_url(record)
  end

  private

  def validate_default_timing(record)
    return if %w[real game].include?(record.default_timing)
    record.errors[:base] << 'Default timing must be either "real" or "game".'
  end

  def validate_video_url(record)
    record.video_url.try(:strip!)
    if record.video_url.blank?
      record.video_url = nil
      return
    end

    unless valid_domain?(record.video_url)
      record.errors[:base] << 'Your video URL must be a link to a Twitch or YouTube video.'
    end
  rescue URI::InvalidURIError
    record.errors[:base] << 'Your video URL must be a link to a Twitch or YouTube video.'
  end

  def valid_domain?(url)
    uri = URI.parse(url)
    uri.host.present? && uri.host.match?(/^(www\.)?(twitch\.tv|youtube\.com|youtu\.be)$/)
  end
end
