default:
	ruby lilyjunk.rb > music.ly
	lilypond music.ly
	pkill -HUP mupdf
