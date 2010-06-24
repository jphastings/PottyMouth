require 'git'
require 'fileutils'


def check_repo(details)    
  re = //
  open("words.txt") do |f|
    words = f.read.split("\n")
    # Words should all be in lowercase
    words = words.collect do |word|
      ["(?:[^a-zA-Z]|^)(#{word}(?:#{word[-1..-1]}?(?:ing|ed|er))?)","(?:[^a-zA-Z]|^)(#{word.upcase}(?:#{word.upcase[-1..-1]}?(?:ING|ED|ER))?)","(#{word.capitalize}(?:#{word[-1..-1]}?(?:ing|ed|er))?)"]
    end.flatten
    re = Regexp.new(words.join("|"))
  end

  repo = File.join('tmp',(0..32).map{ [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten[rand(52)]  }.join)
  
  begin
    Git.clone(details[:giturl],repo)
    
    # Searches commits now too, I think?
    #FileUtils.rm_rf(File.join(repo,'.git')) # don't need to worry about making sure there's no foul play here, heroku is read-only
    
    Swear.find_by_sql(['DELETE FROM swears WHERE repo = ? AND user = ?',details[:repo],details[:user]])

    swears = {}

    Dir.glob(File.join('.','**/**'),File::FNM_DOTMATCH) do |file|
      if !File.directory? file
        f = open(file)
        f.read.scan(re).each do |swear|
          $stderr.puts "Found #{swear.compact[0].downcase} in #{file}"
          swears[swear.compact[0].downcase] = (swears[swear.compact[0].downcase] || 0) + 1
        end
        f.close
      end
    end

    swears.each_pair do |swear,count|
      s = Swear.create(:repo => details[:repo],:user => details[:user],:swear => swear,:count => count)
      s.save
    end
  ensure
    FileUtils.rm_rf(repo)
  end
end