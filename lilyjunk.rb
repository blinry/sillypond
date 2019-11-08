class String
    def titlecase
        split(" ").map { |word|
            if %w(for the and a in of).include?(word)
                word
            else
                word.capitalize
            end
        }.join(" ")
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
    d = %w(2 4 4 4 4 8 8 8 8 16 16 16 16 32 32 32 32).sample
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

def maybeslur
    r = rand
    if r > 0.4
        if rand > 0.5
            "("
        else
            ")"
        end
    elsif r > 0.35
        if rand > 0.5
            "\\<"
        else
            "\\>"
        end
    else
        ""
    end
end

def note
    if rand > 0.5
        "\\absolute "+absolute_pitch_or_rest
    else
        pitch_or_rest
    end + duration+articulation+maybeslur+maybetie+noteappend
end

def object
    if rand > 0.3
        %w(a the your).sample+" "+%w(choir bow piano tuba tuna cello violin drum uke bell gong nose lemon kraken cow cat dog conductor thigh head elbow).sample
    else
        (%w(peanuts spaghetti audience your) + [
            "the white keys",
            "the black keys",
            "the person next to you",
        ]).sample
    end
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
    (%w(fix oil shake tap remove add sell burn tune admire destroy eat pet slap swallow release)+[
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
    ]).sample
end

def when?
    [
        "",
        "here",
        "now",
        "...now!",
        "... now ... and ... now!!",
        "immediately",
        "during this part",
        "a few times",
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
        "go to bar #{rand(1..20)}"
    ].sample
end

def iff
    ["if", "in case", "assuming"].sample + " " + [
        "#{object} is present",
        "there is #{object}",
        "nothing is on fire",
        "you have #{object}"
    ].sample + ", "
end

def instruction
    commands = [
        "#{active_verb} #{object}",
        "#{iff} #{active_verb} #{object}",
        "#{active_verb} #{object} #{when?}",
        "#{passive_verb} #{when?}",
        "#{adjective}",
        "#{adjective} and #{adjective}",
        exclamation
    ].sample
end

def articulation
    if rand > 0.95
        %w(\fermata \prall \turn \staccato \trill).sample
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
    if rand > 0.8
        "#{dir}\\markup{#{format(instruction+instruction_addendum)}}"
    elsif rand > 0.78
        "\\"+%w(ppppp pppp ppp pp p mp mf f ff fff ffff fffff fp sf sff sp spp sfz rfz).sample
    else
        ""
    end
end

def chord
    maybe_absolute+"<" + (1..rand(2..3)).map{pitch}.join(" ")+ ">"
end

def marktext
    tempo = [
         "Alligator",
         "Pesto",
         "Rigatoni",
         "Gravel",
         "Lamborghini",
         "Arghissimo",
         "Aldente",
         "Molten",
         "Mold",
         "Tutti",
         "Solo",
    ].sample
    if rand > 0.2
        [
         "As #{adjective} as possible",
         "With #{object}",
         "Like #{object}",
         tempo
        ].sample
    else
        instruction.capitalize
    end
end

def mark
    "\\mark " + if rand > 0.1
        "\"#{marktext}\" "
    else
        "\\default"
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
        mark,
        "\\autoBeamOff",
        "\\autoBeamOn",
    ].sample
end

def thing
    r = rand
    if r > 0.05
        if rand > 0.2
            note
        else
            chord
        end
    else
        special_thing
    end
end

def clef
    return "G"
    %w(bass tenor alto treble french soprano GG percussion).sample
end

def time
    %w(4/4 2/2 3/4 8/8).sample
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

puts <<HERE
\\version \"2.18.2\"
#(set! paper-alist (cons '("sticker" . (cons (* 200 mm) (* 50 mm))) paper-alist))
#(set-default-paper-size "a4")

\\header {
    tagline = ""
    title = "#{title}"
}

HERE

    #composer = "R. Andom"

puts "\\score {"

    puts "\\new Voice \\with {
        \\remove \"Note_heads_engraver\"
        \\consists \"Completion_heads_engraver\"
        \\remove \"Rest_engraver\"
        \\consists \"Completion_rest_engraver\"
     }"

    puts "\\relative c''
    {"

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

    #    puts "Lorem ip -- sum do -- lor sit a -- met, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

    #puts "}"

    puts "\\midi { }"
    puts "\\layout { }"

puts "}"
