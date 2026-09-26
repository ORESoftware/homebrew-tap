#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "uri"

ALLOWED_CLIS = %w[ores-stack bmscl bmscl-gleam scintilla].freeze
TARGET_ARCH = {
  "aarch64-apple-darwin" => "arm64",
  "x86_64-apple-darwin" => "x86_64"
}.freeze
SHA256 = /\A[0-9a-f]{64}\z/
COMMIT = /\A[0-9a-f]{40}\z/
REPOSITORY = /\A[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+\z/
FILENAME = /\A[A-Za-z0-9][A-Za-z0-9._+-]*\z/
VERSION = /\A[A-Za-z0-9][A-Za-z0-9._+-]*\z/
TAG = /\A[A-Za-z0-9][A-Za-z0-9._\/+~-]*\z/


def fail_receipt(message)
  warn("promotion receipt invalid: #{message}")
  exit(1)
end


def require_exact_keys(value, expected, context)
  fail_receipt("#{context} must be an object") unless value.is_a?(Hash)

  actual = value.keys.sort
  wanted = expected.sort
  return if actual == wanted

  fail_receipt("#{context} keys must be exactly #{wanted.join(', ')}; got #{actual.join(', ')}")
end


def require_string(value, pattern, context, max: nil)
  fail_receipt("#{context} must be a string") unless value.is_a?(String)
  fail_receipt("#{context} exceeds #{max} bytes") if max && value.bytesize > max
  fail_receipt("#{context} has an invalid shape") unless pattern.match?(value)
end

path = ARGV.fetch(0) do
  warn("usage: ruby tools/verify-promotion-receipt.rb RECEIPT.json")
  exit(2)
end

begin
  receipt = JSON.parse(File.read(path, encoding: "UTF-8"))
rescue JSON::ParserError, Errno::ENOENT => error
  fail_receipt(error.message)
end

require_exact_keys(
  receipt,
  %w[byte_identical cli formula private_artifact public_artifact schema_version source version],
  "receipt"
)

fail_receipt("unsupported schema_version") unless receipt["schema_version"] == "ores.homebrew.cli-promotion/v1"
cli = receipt["cli"]
fail_receipt("unsupported cli #{cli.inspect}") unless ALLOWED_CLIS.include?(cli)
version = receipt["version"]
require_string(version, VERSION, "version", max: 128)
fail_receipt("byte_identical must be true") unless receipt["byte_identical"] == true

source = receipt["source"]
require_exact_keys(source, %w[commit repository tag], "source")
require_string(source["repository"], REPOSITORY, "source.repository", max: 256)
require_string(source["commit"], COMMIT, "source.commit")
require_string(source["tag"], TAG, "source.tag", max: 128)
unless [version, "v#{version}"].include?(source["tag"])
  fail_receipt("source.tag must equal version or v<version>")
end

private_artifact = receipt["private_artifact"]
require_exact_keys(private_artifact, %w[filename sha256 target], "private_artifact")
require_string(private_artifact["filename"], FILENAME, "private_artifact.filename", max: 256)
require_string(private_artifact["sha256"], SHA256, "private_artifact.sha256")
target = private_artifact["target"]
expected_arch = TARGET_ARCH[target]
fail_receipt("Homebrew promotion requires an Apple target, got #{target.inspect}") unless expected_arch

public_artifact = receipt["public_artifact"]
require_exact_keys(
  public_artifact,
  %w[filename public_access_verified sha256 url],
  "public_artifact"
)
require_string(public_artifact["filename"], FILENAME, "public_artifact.filename", max: 256)
require_string(public_artifact["sha256"], SHA256, "public_artifact.sha256")
fail_receipt("public_access_verified must be true") unless public_artifact["public_access_verified"] == true
fail_receipt("public filename must equal private filename") unless public_artifact["filename"] == private_artifact["filename"]
fail_receipt("public SHA-256 must equal private SHA-256") unless public_artifact["sha256"] == private_artifact["sha256"]

begin
  public_uri = URI.parse(public_artifact["url"])
rescue URI::InvalidURIError => error
  fail_receipt("public_artifact.url: #{error.message}")
end

fail_receipt("public_artifact.url must use https") unless public_uri.scheme == "https"
fail_receipt("public_artifact.url must name a host") if public_uri.host.nil? || public_uri.host.empty?
fail_receipt("public_artifact.url must not contain credentials") if public_uri.userinfo
fail_receipt("public_artifact.url must not contain a query") if public_uri.query
fail_receipt("public_artifact.url must not contain a fragment") if public_uri.fragment
fail_receipt("public_artifact.url must end in the promoted filename") unless File.basename(public_uri.path) == public_artifact["filename"]

formula = receipt["formula"]
require_exact_keys(formula, %w[arch name os], "formula")
fail_receipt("formula.name must match cli") unless formula["name"] == cli
fail_receipt("formula.os must be macos") unless formula["os"] == "macos"
fail_receipt("formula.arch does not match private target") unless formula["arch"] == expected_arch

puts("promotion receipt valid: #{cli}@#{version} #{target} #{private_artifact['sha256']}")
