# Checks an uploaded profile photo and shrinks it before it's stored, so the
# server only ever keeps a small 512x512 WebP (usually 20-60 KB), never the
# original phone photo.
class AvatarUpload
  MAX_BYTES = 10.megabytes
  SIZE = 512
  TYPES = %w[image/jpeg image/png image/webp image/heic image/heif].freeze

  class Error < StandardError; end

  # Takes an uploaded file and returns something `user.avatar =` accepts.
  # Raises AvatarUpload::Error with a message for the form when it isn't usable.
  def self.process(file)
    raise Error, "must be 10 MB or smaller" if file.size > MAX_BYTES

    # Look at the file's contents, not just its name, to tell what it really is.
    type = Marcel::MimeType.for(file.tempfile, name: file.original_filename)
    raise Error, "must be a JPG, PNG, WebP or HEIC photo" unless TYPES.include?(type)

    shrink(file.tempfile.path)
  end

  # Crops to a centred square, resizes and saves as WebP without metadata
  # (which also drops any GPS location stored in phone photos).
  def self.shrink(path)
    output = ImageProcessing::Vips
               .source(path)
               .autorot
               .resize_to_fill(SIZE, SIZE)
               .convert("webp")
               .saver(quality: 82, strip: true)
               .call
    { io: output, filename: "avatar.webp", content_type: "image/webp" }
  rescue Vips::Error, ImageProcessing::Error
    raise Error, "couldn't be read as a photo. Try a different one"
  end
end
