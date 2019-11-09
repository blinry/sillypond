default:
	#ruby sillypond.rb
	ruby sillypond.rb > music.ly
	lilypond music.ly
	pkill -HUP mupdf
