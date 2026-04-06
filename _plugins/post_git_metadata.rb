# frozen_string_literal: true

require "digest"
require "open3"

module Jekyll
  class PostGitMetadataGenerator < Generator
    safe true
    priority :low

    def generate(site)
      repository = site.config["repository"].to_s.strip
      return if repository.empty?

      site.posts.docs.each do |doc|
        path = doc.relative_path.to_s.sub(%r!\A/!, "")
        next if path.empty?

        commit = latest_commit(site.source, path)
        next unless commit

        sha, committed_at = commit
        doc.data["last_modified_at"] ||= committed_at
        doc.data["latest_diff_url"] ||= github_diff_url(repository, sha, path)
      end
    end

    private

    def latest_commit(source, path)
      output, status = Open3.capture2(
        "git",
        "log",
        "-1",
        "--format=%H%x1f%cI",
        "--",
        path,
        chdir: source
      )
      return unless status.success?

      sha, committed_at = output.strip.split("\u001f", 2)
      return if sha.to_s.empty? || committed_at.to_s.empty?

      [sha, committed_at]
    rescue StandardError
      nil
    end

    def github_diff_url(repository, sha, path)
      anchor = Digest::SHA256.hexdigest(path)
      "https://github.com/#{repository}/commit/#{sha}#diff-#{anchor}"
    end
  end
end
