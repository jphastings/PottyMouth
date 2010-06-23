require 'git'
require 'fileutils'


def check_repo(details)
  # Don't do the same one twice
  #return if Repo.count(:name => details[:repo], :user => details[:user],:repo_hash => details[:hash]) > 0
    
  re = //
  open("words.txt") do |f|
    words = f.read.split("\n")
    # Words should all be in lowercase
    words = words.collect do |word|
      ["(?:[^a-zA-Z]|^)(#{word})(?:[^a-zA-Z]|$)","(?:[^a-zA-Z]|^)(#{word.upcase})(?:[^a-zA-Z]|$)","(#{word.capitalize})"]
    end.flatten
    re = Regexp.new(words.join("|"))
  end

  repo = File.join('tmp',details[:hash])
  
  begin
    Git.clone(details[:giturl],repo)

    FileUtils.rm_rf(File.join(repo,'.git')) # don't need to worry about making sure there's no foul play here, heroku is read-only
    
    r = Repo.create(:name => details[:repo], :user => details[:user],:repo_hash => details[:hash])
  
    Dir.glob(File.join(repo,'**/**')) do |file|
      if !File.directory? file
        f = open(file)
        f.read.scan(re).each do |swear|
          s = r.swears.find_or_create_by_swear(swear.compact[0].downcase)
          s.count += 1
          s.save
        end
        f.close
      end
    end
  ensure
    FileUtils.rm_rf(repo)
  end
end