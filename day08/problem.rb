TEST = ARGV.delete('-t')
input = if TEST
	['', '', '', '', '']
else
	ARGV.empty? ? INPUT : ARGF.each_line
end
