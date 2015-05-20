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

      stdout_str = nil
      stderr_str = nil

      Open3.popen3("#{PECO_BIN} --null --prompt #{Shellwords.escape(prompt)}") do |stdin, stdout, stderr, wait_thr|
        candidates.each do |display, value|
          value ||= display
          stdin.puts "#{display}\x00#{value.object_id}"
        end
        stdin.close

        stdout_str = stdout.read
        stderr_str = stderr.read

        unless wait_thr.value.exitstatus == 0
          $stdout.print stdout_str
          $stderr.print stderr_str
          abort
        end
      end

      object_ids = stdout_str.strip.split("\n").map(&:to_i)

      candidates.map do |display, value|
        value || display
      end.select do |value|
        object_ids.include?(value.object_id)
      end
    end
  end
end
