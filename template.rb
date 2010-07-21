# Generated by Nick Markwell's (duckinator) %class% class on %time%
  
require 'stringio'
require 'etc'
require %file%

nobody_uid = Etc.getpwnam('nobody').uid
nobody_gid = Etc.getgrnam('nobody').gid

Dir.chroot(%chroot%)
Dir.chdir("/")

Process.initgroups('nobody', nobody_gid)
Process::GID.change_privilege(nobody_gid)
Process::UID.change_privilege(nobody_uid)

if Process.uid != nobody_uid
  puts "Error setting up chroot"
  exit
end

command = %code%

output, result = ''
seval, error = nil

begin
  output = out_to_string do
    seval = %class%.new
    result = seval.eval command
  end
rescue Exception => e
  error = e
ensure
  $stdout = STDOUT
end

error ||= seval.error

begin
  if !error.nil? && output.empty?
    puts "#{error.class}: #{error.message}"
  elsif !output.empty?
    puts output
  else
    puts result.inspect
  end
rescue => e
  puts "#{e.class}: #{e.message}"
end
