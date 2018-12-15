TEST = ARGV.delete('-t')

d = if TEST
	'2x3x4'
else
	ARGV.empty? ? INPUT : ARGF
end
n = d.each_line.map { |l|
	l.split('x').map(&:to_i).freeze
}.freeze
t = []
rb = []
def rbc(ar)
	2*ar[0]+2*ar[1]
end
n.each { |a|
	sm = [2*a[0]*a[1],2*a[1]*a[2],2*a[0]*a[2]]
	m = sm.sort[0]
	t.push(sm.sum + (m/2))
	rb.push(rbc(a.sort[0..1])+a[0]*a[1]*a[2])
}
puts "P01: #{t.sum} -///- P02: #{rb.sum}"