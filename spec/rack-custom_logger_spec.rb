require 'rack/lint'
require 'rack/mock'
require 'daily_logger'
require 'timecop'
require 'rack/custom_logger'
require 'logger'

require File.dirname(__FILE__) + '/spec_helper'

describe Rack::CustomLogger do

  app = lambda { |env|
    log = env['rack.logger']
    log.debug("Created logger")
    log.info("Program started")
    log.warn("Nothing to do!")

    [200, {'Content-Type' => 'text/plain'}, ["Hello, World!"]]
  }

  let(:log_dir) { "#{File.dirname(__FILE__)}/log" }
  let(:today)     {Time.now.strftime "%Y%m%d"}
  let(:now)       {Time.now.strftime "%Y/%m/%d %H:%M:%S"}

  before do
    Dir.mkdir(log_dir)
    Timecop.freeze(Time.now)
  end

  after do
    # サブディレクトリを階層が深い順にソートした配列を作成
    dirlist = Dir::glob(log_dir + "**/").sort do |a,b|
      b.split('/').size <=> a.split('/').size
    end

    dirlist.each do |d|
      Dir::foreach(d) do |f|
        File::delete(d+f) if ! (/\.+$/ =~ f)
      end
      Dir::rmdir(d)
    end
    Timecop.return
  end

  context 'conform to Rack::Lint' do
    subject {Rack::Lint.new( Rack::CustomLogger.new(app, DailyLogger.new("#{log_dir}/test")) )}
    it do
      Rack::MockRequest.new(subject).get('/')
      expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\tProgram started\n"
      expect(File.read("#{log_dir}/test.warn.log.#{today}")).to eq "[#{now}]\tNothing to do!\n"
    end
  end

  context 'conform to Rack::Lint' do
    subject {Rack::Lint.new( Rack::CustomLogger.new(app, DailyLogger.new("#{log_dir}/test"), ::Logger::DEBUG) )}
    it do
      Rack::MockRequest.new(subject).get('/')
      expect(File.read("#{log_dir}/test.debug.log.#{today}")).to eq "[#{now}]\tCreated logger\n"
      expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\tProgram started\n"
      expect(File.read("#{log_dir}/test.warn.log.#{today}")).to eq "[#{now}]\tNothing to do!\n"
    end
  end

end


