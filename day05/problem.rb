require 'digest'
TEST = ARGV.delete('-t')
input = if TEST
	['ugknbfddgicrmopa','aeroacdttieaoiea','jcdzalrnumiwwwpz','qjhvhtzxzqqjkmpb','xxyxx','uurcxstgmygtbstg','ieodomkazucvgmuy']
else
	ARGV.empty? ? INPUT : ARGF.each_line.freeze
end
v = 'aeiou'
n = ['ab','cd','pq','xy']
nc = nd = 0
input.each { |i|
	is = i.split('')
	vw = is.map { |isv| v.include?(isv) ? 1 : 0 }
	dl = dw = tw = false
	ni = n.map { |nv| i.include?(nv) ? 1 : 0 }
	is.each_with_index { |isv,ix|
		if ix != 0 && is[ix-1] == is[ix] then
			dl = true
		end
		if ix <= is.length - 3 && is[ix+2] == is[ix] then
			dw = true
		end
		if ix <= is.length - 4 then
			pr = is[ix]+is[ix+1]
			if i[ix+2..-1].index(pr) != nil then tw = true end
		end
	}
	nc += 1 if vw.sum >= 3 && dl && ni.sum == 0
	nd += 1 if dw && tw
}
puts "P01: #{nc} -///- P02: #{nd}"