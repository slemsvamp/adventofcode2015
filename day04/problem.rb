require 'digest'
TEST = ARGV.delete('-t')
input = if TEST
	'abcdef'
else
	ARGV.empty? ? INPUT : ARGF.read
end
i = 0
p1 = nil
while true do
	i+=1
	d = Digest::MD5.hexdigest(input + i.to_s())
	if p1 == nil && d[0..4] == '00000' then p1 = i end
	break if d[0..5] == '000000'
end
puts "P01: #{p1} -///- P02: #{i}"