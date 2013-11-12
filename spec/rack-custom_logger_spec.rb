require 'rack/lint'
require 'rack/mock'
require 'daily_logger'
require 'timecop'

describe Rack::CustomLogger do
  let(:app) do |env|
    log = env['rack.logger']
    log.debug("Created logger")
    log.info("Program started")
    log.warn("Nothing to do!")

    [200, {'Content-Type' => 'text/plain'}, ["Hello, World!"]]
  end
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
    subject {Rack::Lint.new( Rack::CustomLogger.new(app, DailyLogger("#{log_dir}/test")) )}
    it do
      Rack::MockRequest.new(subject).get('/')
      expect(File.read("#{log_dir}/test.info.log.#{today}")).to eq "[#{now}]\tProgram started\n"
    end
  end
end


