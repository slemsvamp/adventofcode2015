TEST = ARGV.delete('-t')
input = if TEST
	['turn on 0,0 through 9,9',
	 'turn off 4,4 through 8,8',
	 'toggle 5,5 through 7,7']
else
	ARGV.empty? ? INPUT : ARGF.each_line
end
$g = Array.new { 0 }
$g2 = Array.new { 0 }
(0..999_999).each do |i|
	$g[i] = 0
	$g2[i] = 0
end
# z: 0 turn off, 1 turn on, 2 toggle
def act(x1,y1,x2,y2,z)
	(x1..x2).each do |x|
		(y1..y2).each do |y|
			i = y*1000+x
			$g[i] = z == 2 ? ($g[i] == 0 || $g[i] == nil ? 1 : 0) : z
			$g2[i] += z == 0 ? -1 : z == 1 ? 1 : 2
			$g2[i] = 0 if $g2[i] < 0
		end
	end
end
input.map.each { |l|
	off = /^turn off (\d+),(\d+) through (\d+),(\d+)/.match(l)
	act(off[1].to_i,off[2].to_i,off[3].to_i,off[4].to_i,0) if off != nil
	on = /^turn on (\d+),(\d+) through (\d+),(\d+)/.match(l)
	act(on[1].to_i,on[2].to_i,on[3].to_i,on[4].to_i,1) if on != nil
	tgl = /^toggle (\d+),(\d+) through (\d+),(\d+)/.match(l)
	act(tgl[1].to_i,tgl[2].to_i,tgl[3].to_i,tgl[4].to_i,2) if tgl != nil
}
puts "P01: #{$g.sum} -///- P02: #{$g2.sum}"