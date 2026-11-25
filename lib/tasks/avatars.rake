namespace :avatars do
  desc "Shrink profile photos uploaded before the size limit to 512px WebP"
  task shrink: :environment do
    users = User.joins(:avatar_attachment).includes(avatar_attachment: :blob)
    users.find_each do |user|
      blob = user.avatar.blob
      next if blob.content_type == "image/webp" && blob.byte_size <= 200.kilobytes

      before = blob.byte_size
      blob.open do |file|
        user.avatar.attach(AvatarUpload.shrink(file.path))
      end
      blob.reload.purge # delete the big original now, not in the background
      puts "#{user.username}: #{(before / 1024.0).round} KB -> #{(user.avatar.blob.reload.byte_size / 1024.0).round} KB"
    rescue ActiveRecord::RecordNotFound
      nil # the original was already cleaned up
    rescue AvatarUpload::Error, ActiveStorage::FileNotFoundError => e
      puts "#{user.username}: skipped (#{e.message})"
    end
  end
end
