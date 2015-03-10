require "peco_selector/version"
require 'open3'
require 'shellwords'

module PecoSelector
  def self.select_from(candidates, options = {})
    Selector.new.select_from(candidates, options)
  end

  class Selector
    PECO_BIN = "peco"
    Error = Class.new(StandardError)

    def select_from(candidates, options = {})
      prompt = options[:prompt] || "QUERY>"
      object_ids = nil

      Open3.popen3("#{PECO_BIN} --null --prompt #{Shellwords.escape(prompt)}") do |stdin, stdout, stderr, wait_thr|
        candidates.each do |display, value|
          stdin.puts "#{display}\x00#{value.object_id}"
        end
        stdin.close

        object_ids = stdout.read.strip.split("\n").map(&:to_i)

        unless wait_thr.value.exitstatus == 0
          $stdout.print stdout.read
          $stderr.print stderr.read
          abort
        end
      end

      candidates.each_value.select do |value|
        object_ids.include?(value.object_id)
      end
    end
  end
end
