default:
	#ruby lilyjunk.rb
	ruby lilyjunk.rb > music.ly
	lilypond music.ly
	pkill -HUP mupdf
