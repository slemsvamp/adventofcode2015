TEST = ARGV.delete('-t')
input = if TEST
	'^>v<^^>>'
else
	ARGV.empty? ? INPUT : ARGF.read
end
$s = []
(1..3).each { $s.push({ "x" => 0, "y" => 0 }) }
$cl = [{},{}]
def mv(c, m)
	if c == '^' then $s[m]["y"]-=1 end
	if c == '<' then $s[m]["x"]-=1 end
	if c == '>' then $s[m]["x"]+=1 end
	if c == 'v' then $s[m]["y"]+=1 end
	x = $s[m]["x"]
	y = $s[m]["y"]
	z = m == 0 ? 0 : 1 # two collections, one for each part
	if $cl[z]["#{x},#{y}"] == nil then
		$cl[z]["#{x},#{y}"] = 0
	end
	$cl[z]["#{x},#{y}"] += 1
end
m = {}
input.split('').each_with_index do |c, i|
	mv(c, 0)
	mv(c, i % 2 == 0 ? 1 : 2)
end
puts "P01: #{$cl[0].length} -///- P02: #{$cl[1].length}"