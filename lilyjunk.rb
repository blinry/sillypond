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
    %w(a b c d e f g).sample
end

def minmaj
    %w(minor major).sample
end

def pitch
    octaves = %w(' ,) << ""
    return pitchname
    pitchname+octaves.sample
end

def pitch_or_rest
    if rand > 0.05
        pitch
    else
        "r"
    end
end

def maybe_absolute
    if rand > 0.8
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
    maybe_absolute+pitch_or_rest+duration+articulation+maybeslur+maybetie+noteappend
end

def object
    if rand > 0.3
        %w(a the your).sample+" "+%w(choir bow piano tuba tuna drum uke bell nose shoulder lemon kraken cow cat dog).sample
    else
        %w(peanuts spaghetti audience).sample
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
    (%w(fix oil shake tap remove add sell burn tune admire destroy eat pet swallow release)+[
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
    ]).sample
end

def when?
    [
        "",
        "here",
        "now",
        "immediately",
        "during this part",
        "a few times",
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
        "um...",
    ].sample
end

def instruction
    commands = [
        "#{active_verb} #{object}",
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
    maybe_absolute+"<" + (1..rand(2..10)).map{pitch}.join(" ")+ ">"
end

def marktext
    tempo = [
         "Alligator",
         "Pesto",
         "Gravel",
         "Lamborghini",
         "Arghissimo",
         "Aldente",
         "Con moth",
         "Molten",
         "Mold",
         "Lentils",
    ].sample
    if rand > 0.2
        [
         "As #{adjective} as possible",
         "With #{object}",
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

def bar
    "\\bar \"#{%w(| . |. .| || .. |.| ; ! .|: :..: :|.|: :|.: :.|.: [|: :|][|: :|] :|. ' k S [ ]).sample}\""
end

def special_thing
    [
        timesig,
        clefsig,
        bar,
        mark
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
    %w(bass tenor alto treble french soprano GG percussion).sample
end

def time
    %w(4/4 2/2 3/4 8/8).sample
end

def adjective
    (%w(careful reckless silly serious playful light airy heavy grumpy fast quick slow sleepy evil strong weak determined convincing attentive)).sample
end

def modifier
   %w(death fairie's last evil wicked solo violin church string).sample
end

def titlepart
    mod = if rand > 0.5
              modifier
          else
              ""
          end

    type = (%w(symphonie waltz march prelude quartet aire ballet opera canon song sonata concerto trio) + [
        "string quartet",
    ]).sample
    "#{modifier} #{type}"
end

def title
    [
        titlepart+" in "+pitchname+" "+minmaj,
        titlepart+" No. #{rand(1..20)}",
        titlepart+" for #{object}",
        titlepart+" and "+titlepart
    ].sample.titlecase
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

    puts "\\relative c'' {"

        puts "\\autoBeamOff "

        puts clefsig
        puts timesig
        print mark

        300.times do
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
