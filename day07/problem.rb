TEST = ARGV.delete('-t')
input = if TEST
	['123 -> x', '456 -> y', 'x AND y -> d', 'x OR y -> e', 'x LSHIFT 2 -> f', 'y RSHIFT 2 -> g', 'NOT x -> h', 'NOT y -> i', 'd AND 34 -> k']
else
	ARGV.empty? ? INPUT : ARGF.each_line
end
def createAnd(a,b,c) { 'tp' => 'and', 'p1' => a, 'p2' => b, 't' => c } end
def createOr(a,b,c) { 'tp' => 'or', 'p1' => a, 'p2' => b, 't' => c } end
def createConstant(a,b) { 'tp' => 'constant', 'p1' => a.to_i, 't' => b } end
def createNot(a,b) { 'tp' => 'not', 'p1' => a, 't' => b } end
def createShift(a,b,c,d) { 'tp' => "shift#{c}", 'p1' => a, 'p2' => b, 't' => d } end
#def isNumeric(pm) !!/[0-9]+/.match(pm) end
def addIfMissing(t,pm)
	$w[t] = { 'r' => [] } if !$w[t]
	if pm != nil then # !isNumeric(pm)
		$w[pm] = { 'r' => [] } if !$w[pm]
		$w[t]['r'].push(pm) if !$w[t]['r'].include?(pm)
	end
end
i = []
$c = []
$w = {}
v = []
input.map { |l|
	inp, o = /(.+) -> (\w+)/.match(l).captures
	m = /(?<digits>\d+)|(?<and>.+ AND .+)|(?<not>NOT .+)|(?<or>.+ OR .+)|(?<shift>.+ \wSHIFT \d+)/.match(inp)
	if !!m
		$c.push(createConstant(m[0], o)) if !!m['digits']
		$c.push(createShift(v[1], v[3], v[2], o)) if !!m['shift'] && !!v = /(.+) (L|R)SHIFT (\d+)/.match(inp)
		$c.push(createAnd(v[1], v[2], o)) if !!m['and'] && !!v = /(.+) AND (.+)/.match(inp)
		$c.push(createNot(v[1], o)) if !!m['not'] && !!v = /NOT (.+)/.match(inp)
		$c.push(createOr(v[1], v[2], o)) if !!m['or'] && !!v = /(.+) OR (.+)/.match(inp)
	end
}
$c.each { |n|
	tp = n['tp']
	t = n['t']
	p1 = n['p1']
	p2 = n['p2']
	addIfMissing(t,p1)
	addIfMissing(t,p2)
}
def solve(s)
	puts $w
	cl = $w[s]['r']

	# is there a constant for this wire?
	print "is there a constant for #{s}?"
	cs = $c.find { |n| n['tp'] == 'constant' && n['t'] == s }
	if cs != nil && cs.length > 0 then
		$w[s]['v'] = cs['p1']
		print 'yes.'
		return cs['p1']
	end

	# foreach in cl, check if it has a value, else solve it
	cl.each { |i|
		print "is there a value for #{i}?"
		if $w[i]['v'] == nil then
			$w[i]['v'] = solve(i)
			print 'yes.'
		end
	}

	# do the gate logic
	g = $c.find { |cs| cs['t'] == s }
	result = 0
	if g['tp'] == 'and' then
		return $w[g['p1']]['v'] & $w[g['p2']]['v']
	elsif g['tp'] == 'or' then
		return $w[g['p1']]['v'] | $w[g['p2']]['v']
	elsif g['tp'] == 'not' then
		return ~$w[g['p1']]['v']
	elsif g['tp'] == 'shiftL' then
		return $w[g['p1']]['v'] << $w[g['p2']]['v']
	elsif g['tp'] == 'shiftR' then
		return $w[g['p1']]['v'] >> $w[g['p2']]['v']
	end

	return nil
end
print solve('a')