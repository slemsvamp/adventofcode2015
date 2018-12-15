c = (ARGV.empty? ? INPUT : ARGF).each_line.map(&:to_s).freeze[0].split('')
f = m = 0
m-=1
c.each_with_index do |c,n|
	if f == -1 && m < 0 then m = n end
	f += (c == '(' ? 1 : -1)
end
puts "P01: #{f} -///- P02: #{m}"