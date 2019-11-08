#require "active_support/inflector"
require "linguistics"

Linguistics.use(:en)#, monkeypatch: true)

class String
    def titlecase
        capitalize.split(" ").map { |word|
            if %w(for the and a in of).include?(word)
                word
            else
                word.capitalize
            end
        }.join(" ").gsub("a Major", "A Major")
    end

    def s
        self.en.plural
    end

    def a
        self.en.a
    end
end

def pitchname
    raw = %w(a b c d e f g).sample
    if rand > 0.05
        raw
    else
        accidental = %w(is es).sample
        raw+accidental
    end
end

def minmaj
    %w(minor major).sample
end

def absolute_pitch
    octave = %w(' '').sample
    reminder = if rand > 0.05
                   ""
               else
                   %w(! ?).sample
               end
    return pitchname+octave+reminder
end

def pitch
    reminder = if rand > 0.05
                   ""
               else
                   %w(! ?).sample
               end
    pitchname+reminder
end

def absolute_pitch_or_rest
    if rand > 0.1
        absolute_pitch
    else
        "r"
    end
end

def pitch_or_rest
    if rand > 0.1
        pitch
    else
        "r"
    end
end

def maybe_absolute
    if rand > 0.9
        "\\absolute "
    else
        ""
    end
end

def duration
    #d = %w(2 4 4 4 4 8 8 8 8 16 16 16 16 32 32 32 32).sample
    d = %w(2 4 4 8 8 8 8 16 16 32 32).sample
    if rand > 0.9
        d+"."
    else
        d
    end
end

def maybetie
    if rand > 0.5
        "~"
    else
        ""
    end
end

# segfaults?
def maybebend
    if rand > 0.95
        "\\bendAfter ##{rand(-1.0..1.0)} "
    else
        ""
    end
end

def maybeslur
    r = rand
    if r > 0.4
        if rand > 0.8
            "("
        else
            ")"
        end
    elsif r > 0.35
        if rand > 0.8
            "\\<"
        else
            "\\>"
        end
    else
        ""
    end
end

def maybeinvbar
    if rand > 0.8
        #"\\bar \"\""
        bar
    else
        ""
    end
end

def note
    if rand > 0.5
        "\\absolute "+absolute_pitch_or_rest
    else
        pitch_or_rest
    end + duration+articulation+maybeslur+maybetie+noteappend + maybeinvbar
end

def rawobject
    (%w(choir bow piano tuba tuna cello violin drum sax timpani uke bell gong nose lemon kraken cow otter frog cat dog penguin conductor thigh head elbow bicycle horn trombone trumpet bass flute vibraphone cymbal triangle otamatone cucumber tomato theremin organ) + [
        "tiny snek",
        "white key",
        "black key",
        "peanut",
        "circus clown",
        "circus bear",
        "1st violin",
        "2nd violin",
        "snare drum",
        "english horn",
        "music stand",
        "forest spirit",
    ]).sample
end

def object
    if rand > 0.05
        o = rawobject
        [
            "#{o}",
            "the #{o}",
            "your #{o}",
            "#{o.a}",
            "#{o.s}",
            "some #{o.s}",
        ].sample
    else
        (%w(peanuts spaghetti audience) + [
            "the person next to you",
        ]).sample
    end
end

def objects
    rawobject.s
end

def instruction_addendum
    if rand > 0.95
        " ("+[
            "optional",
            "or don't",
            "important",
            "if you feel like it",
            "maybe",
            "again",
        ].sample + ")"
    else
        ""
    end
end

def active_verb
    (%w(fix oil shake tap remove add sell burn tune admire destroy eat pet slap swallow release hide inflate deflate)+[
        "bring in",
        "continue on",
    ]).sample
end

def passive_verb
    (%w(breathe cough smile laugh moon-walk)+[
        "turn around",
        "jump",
        "cry",
        "sleep",
        "wake up",
        "turn page",
        "stand up",
        "sit down",
        "shut up",
        "meditate",
        "close your eyes",
        "open your eyes",
        "become agitated",
        "mute in",
        "mute out",
        "play ball",
        "duck",
        "untie slip knot",
        "begin to fall",
        "bow real fast",
        "drop your instrument",
        "spam",
        "continue swimming motion",
        "balance your chair on 2 legs",
        "a capella",
        "repeat",
        "fade",
        "use yak-hair bows",
        "whistle",
        "drive it",
        "flutter tongue",
        "go fast",
        "go to bar #{rand(1..20)}",
        "focus",
        "confess",
    ]).sample
end

def when?
    [
        "",
        "- or don't",
        "here",
        "now",
        "...now!",
        "... now ... and ... now!!",
        "immediately",
        "during this part",
        "for a minute",
        "for a while",
        "for two bars",
    ].sample
end

def exclamation
    [
        "all hope is lost",
        "why me?",
        "oh no",
        "have a nice day",
        "what is this",
        "this part is impossible",
        "this is fine",
        "how?",
        "good luck",
        "huh",
        "what.",
        "heh",
        "help",
        "um...",
        "skip this",
        "this was a mistake",
        "don't read this",
    ].sample
end

def instruction
    text = if rand > 0.5
           [
               "#{active_verb} #{object}",
               "#{active_verb} #{object} #{when?}",
               "#{passive_verb} #{when?}",
               "#{adjective}",
               "#{adjective} and #{adjective}",
           ].sample
           else
               [
                   "keep both feet together",
                   "insert peanuts",
                   "cool #{object} with small fan",
                   "#{objects} move downstage",
                   "#{objects} tilt",
                   "light explosives",
                   "cresc.",
                   "dolce",
                   "tranqu.",
                   "con amabilità",
                   "staccato",
                   "non staccato",
                   "turning flame slightly higher and higher",
                   "all harpists stand up and wait",
                   "only #{rand(2..16)} players",
                   "rests are imaginary",
                   "(spoken)",
                   "brightly",
                   "guitar solo",
                   "pizza.",
                   "rit.",
                   "poco a poco",
                   "D.C. al Fine",
                   "scherz.",
                   "molto",
                   "Sopranos only",
                   "left hand, softly",
                   "refrain",
                   "theme",
                   "bend bow to desired shape",
                   "as last time",
                   "procedure as last year",
                   "slowly increase drooling",
                   "this is too easy",
                   "like #{rawobject.a}",
                   "from #{object}",
                   "through #{object}",
                   "with #{object}",
                   "without #{object}",
                   "together with #{object}",
                   "slippery when wet",
                   "feel free to skip this",
                   "come on! faster!",
                   "#{object} has left the building",
                   "glissando using #{object}",
                   "like a polka",
                   "help, I'm trapped in a music factory",
               ].sample
           end + instruction_addendum

    r = rand
    if r > 0.95
        text.upcase
    elsif r > 0.7
        text.capitalize
    elsif r > 0.65
        text + "!"
    else
        text
    end
end

def articulation
    articulations = %w(accent espressivo marcato portato staccatissimo staccato tenuto prall mordent prallmordent turn upprall downprall upmordent downmordent lineprall prallprall pralldown prallup reverseturn trill shortfermata fermata longfermata verylongfermata upbow downbow flageolet snappizzicato open halfopen stopped lheel rheel ltoe rtoe segno coda varcoda)
    if rand > 0.98
        "\\"+articulations.sample+"\\"+articulations.sample
    elsif rand > 0.9
        "\\"+articulations.sample
    else
        ""
    end
end

def format text
    size = %w(huge teeny large small larger smaller normalsize).sample
    series = %w(italic bold medium).sample
    "\\#{size}{\\#{series}{#{text}}}"
end

def noteappend
    dir = %w(^ _).sample
    r = rand
    if r > 0.97
        [
            "\\startTrillSpan",
            "\\sustainOn",
            "\\sustainOff",
        ].sample
    elsif r > 0.7
        "#{dir}\\markup{#{format(instruction)}}"
    elsif rand > 0.4
        [
            "\\"+%w(ppppp pppp ppp pp p mp mf f ff fff ffff fffff fp sf sff sp spp sfz rfz).sample,
            "\\glissando",
            "\\stopTrillSpan",
        ].sample
    else
        ""
    end
end

def maybe_arpeggio
    if rand > 0.9
        "\\arpeggio"
    else
        ""
    end
end

def chord
    maybe_absolute+"<" + (1..rand(2..10)).map{pitch}.join(" ")+ ">"+maybe_arpeggio
end

def marktext
    tempo = [
         "Alligator",
         "Pesto",
         "Rigatoni",
         "Lamborghini",
         "Arghissimo",
         "Aldente",
         "Molten",
         "Tutti",
         "Solo",
    ].sample
    if rand > 0.2
        [
         "As #{adjective} as possible",
         "With #{object}",
         "Like #{rawobject.a}",
         tempo
        ].sample
    else
        instruction.capitalize
    end
end

def mark
    r = rand
    "\\mark " + if r > 0.6
        "\"#{marktext}\" "
    elsif r > 0.2
        "\\default"
    else
        "\\markup { \\musicglyph \"scripts.#{%w(segno coda ufermata).sample}\" }"
    end + " "
end

def timesig
    "\\time #{time}"
end

def clefsig
    "\\clef \"#{clef}\""
end

def keysig
    "\\key #{pitchname} \\#{minmaj} "
end

def bar
    "\\bar \"#{%w(| . |. .| || .. |.| ; ! .|: :..: :|.|: :|.: :.|.: [|: :|][|: :|] :|. ' k S [ ]).sample}\""
end

def special_thing
    [
        timesig,
        clefsig,
        keysig,
        bar,
        "\\autoBeamOff",
        #"\\stopStaff",
        "    \\new Staff \\with {
          \\remove \"Time_signature_engraver\"
          alignAboveContext = #\"main\"
          \\magnifyStaff #2/3
          firstClef = ##f
        } \\relative { #{clefsig} #{pitch}^\\markup{\\large{#{marktext}}} #{(1..rand(5..20)).map{thing}.join(" ")} \\stopStaff }"
    ].sample
end

def notsospecialthing
    [
        "\\slur" + %w(Dashed Dotted Solid Solid Solid).sample,
        #"\\set doubleSlurs = ###{%w(t f).sample}",
        "\\override Glissando.style = #'#{%w(line dashed-line dotted-line zigzag trill).sample}",
        "\\arpeggio" + %w(ArrowUp ArrowDown Normal Bracket Parenthesis ParenthesisDashed).sample,
        "\\set Score.markFormatter = #format-mark-#{["", "box-", "circle-"].sample}alphabet",
        "\\breathe",
        "\\autoBeamOn",
        #"\\startStaff",
        #"\\startStaff",
        #"\\startStaff",
        #"\\startStaff",
        #"\\startStaff",
        #"\\startStaff",
        mark,
    ].sample
end

def thing
    r = rand
    if r > 0.85
        notsospecialthing
    elsif r > 0.8
        special_thing
    else
        if rand > 0.2
            note
        else
            chord
        end
    end
end

def clef
    %w(mensural-g kievan-do percussion tab bass tenor tenorG alto treble french soprano C tenor varC GG).sample
end

def time
    (%w(4/4 2/2 3/4 8/8 7/8) << "#{rand(1..8)}/#{rand(1..8)}").sample
end

def adjective
    (%w(careful reckless silly serious playful light airy heavy grumpy fast quick slow sleepy evil strong deliberately weak determined convincing attentive)).sample
end

def modifier
   %w(death fairie's last evil wicked solo violin church cello valve string infamous vicious maleficent final ultimate).sample
end

def titlepart
    mod = if rand > 0.5
              modifier
          else
              ""
          end

    type = (%w(symphony waltz march prelude quartet aire ballet opera canon song sonata concerto trio duet suite requiem dance) + [
        "string quartet",
    ]).sample
    "#{modifier} #{type}"
end

def title
    result = [
        titlepart+" in "+pitchname+" "+minmaj,
        titlepart+" No. #{rand(1..20)}",
        titlepart+" for #{object}",
        titlepart+" and "+titlepart
    ].sample

    if rand > 0.9
        result << [", Op. #{rand(1..150)}"].sample
    end
    result.titlecase
end

def fromtitle
    [
        "#{object} and #{object}",
        "#{object}",
        "#{instruction}",
    ].sample.titlecase
end

def subtitle
    [
        "For #{rand(2..5)} #{objects} and #{rawobject.a}",
        "For #{rand(2..5)} #{objects}",
        "For #{rawobject.a}, #{rawobject.a}, and #{rawobject.a}",
        "(from “#{fromtitle}”)"
    ].sample
end

def arranger
    if rand > 0.1
        [
            "accident",
            "surprise",
            "mistake",
            "chance",
            "all means",
            "any means",
            "experimentation",
            "foot",
            "luck",
            "a long shot",
            "weight",
            "appointment",
            "far",
            "virtue",
            "default",
            "all appearances",
            "brute force",
            "force",
            "no means",
            "size and weight",
            "nature",
            "design",
            "alphabetical order",
        ].sample
    else
        object
    end
end

puts <<HERE
\\version \"2.19.82\"
%#(set! paper-alist (cons '("sticker" . (cons (* 200 mm) (* 50 mm))) paper-alist))
%#(set-default-paper-size "a4")

\\header {
    tagline = ##f
    title = "#{title}"
    subtitle = "#{subtitle}"
    arranger = "Arranged by #{arranger.titlecase}"
}

HERE

   #composer = "R. Andom"

puts "\\book {"
    puts "\\paper {"
        puts "oddFooterMarkup = \\markup { \\fill-line { \\line { Generated by @blinry for PROCJAM 2019 • CC0 1.0 • https://morr.cc/lilydump/ } } }"
    puts "}"

    puts "\\score {"

        puts "\\new Staff \\with {
            %\\remove \"Note_heads_engraver\"
            %\\consists \"Completion_heads_engraver\"
            %\\remove \"Rest_engraver\"
            %\\consists \"Completion_rest_engraver\"
         }"

        puts "\\relative c''
        {"

            #puts "\\override Glissando.after-line-breaking = ##t"
            #puts "\\override Glissando.breakable = ##t"

            #puts "\\autoBeamOff "

            puts clefsig
            puts keysig
            puts timesig
            print mark

            200.times do
                print "#{thing} "
            end
            print "\\bar \"|.\""
            puts

        puts "}"

        #puts "\\addlyrics {"

        #    puts "Lorem ip -- sum do -- lor sit a -- met, con -- se -- te -- tur a -- di -- pis -- cing e -- lit, sed di -- am no -- nu -- my eir -- mod tem -- por in -- vi -- dunt ut la -- bo -- re et do -- lo -- re ma -- gna a -- li -- quyam e -- rat, sed di -- am vo -- lup -- tu -- a. At ve -- ro e -- os et a -- ccu -- sam et jus -- to du -- o do -- lo -- res et ea re -- bum. Stet cli -- ta kasd gu -- ber -- gren, no se -- a ta -- ki -- ma -- ta sanc -- tus est."

        #puts "}"

    #    puts <<HERE
    #    \\header {
    #        piece = "Based on a cro-magnon skinning chant"
    #    }
    #HERE

        puts "\\midi { }"
        puts "\\layout {
                  %ragged-right = ##t
                  %\\context {
                      %\\Score
                      %\\override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/1)
                  %}
                  \\context {
                      \\Staff
                      \\RemoveEmptyStaves
                  }
            }"

    puts "}"
puts "}"

#20.times do
#    puts "  "+instruction
#end
