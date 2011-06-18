$:.unshift File.dirname(__FILE__) 
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

%w{rubygems gitaculous}.each { |lib| require lib }