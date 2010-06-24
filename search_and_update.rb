require 'git'
require 'fileutils'


def check_repo(details)    
  re = //
  open("words.txt") do |f|
    words = f.read.split("\n")
    # Words should all be in lowercase
    words = words.collect do |word|
      ["(?:[^a-zA-Z]|^)(#{word}(?:#{word[-1..-1]}?(?:ing|ed))?)","(?:[^a-zA-Z]|^)(#{word.upcase}(?:#{word.upcase[-1..-1]}?(?:ING|ED))?)","(#{word.capitalize}(?:#{word[-1..-1]}?(?:ing|ed))?)"]
    end.flatten
    re = Regexp.new(words.join("|"))
  end

  repo = File.join('tmp',(0..32).map{ [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten[rand(52)]  }.join)
  
  begin
    Git.clone(details[:giturl],repo)
    
    # Searches commits now too, I think?
    #FileUtils.rm_rf(File.join(repo,'.git')) # don't need to worry about making sure there's no foul play here, heroku is read-only
    
    Swear.transaction do
      Swear.destroy_all(['repo = ? AND user = ?',details[:repo],details[:user]])
          
      Dir.glob(File.join(repo,'**/**')) do |file|
        if !File.directory? file
          f = open(file)
          f.read.scan(re).each do |swear|
            s = Swear.find_or_create_by_repo_and_user_and_swear(details[:repo],details[:user],swear.compact[0].downcase)
            s.count += 1
            s.save
          end
          f.close
        end
      end
    end
  ensure
    FileUtils.rm_rf(repo)
  end
end