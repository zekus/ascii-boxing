require "pry"
require "pry-debugger"
require "bundler/setup"
require "gaminator"

module ASCIILoving
  class Heart < Struct.new(:x, :y)
    def texture
      [
        ',d88b.d88b,',
        '88888888888',
        '`Y8888888Y',
        '  `Y888Y',
        '    `Y',
      ]
    end
  end

  class Lover
    attr_accessor :x, :y

    LOVER_LEFT =
      [
     '/```\ ',
     '%    )',
     '\___/',
     ' | |',
     '(   =====@',
     '#####',
     '#####',
     '1   1',
     '1    2',
     '1     2'
      ]

    LOVER_RIGHT =
      [
     '     /```\ ',
     '    (     %',
     '     \___/',
     '      | |',
     '  @===== )',
     '     #####',
     '     #####',
     '     1   1',
     '    1    2',
     '   1     2'
      ]

    def initialize(x, y, options = {})
      self.x = x
      self.y = y
      side = options[:side] || "left"
      @color = options[:color] || Curses::COLOR_RED
      @texture = side == "left" ? LOVER_LEFT[0] : LOVER_RIGHT[0]
    end

    def color
      @color
    end

    def texture
      @texture
    end

    def width
      @_width ||= texture.max_by{ |x| x.length }.length
    end
  end

  class Game
    attr_accessor :textbox_content, :objects

    def initialize(width, height)
      @lover_a = Lover.new(5, 5)
      @lover_b = Lover.new(20, 5, {side: "right", color: Curses::COLOR_BLUE})

      @textbox_content = default_message
      @objects = [@lover_b, @lover_a]
    end

    def input_map
      {
      ?a => :move_left_lover_a,
      ?d => :move_right_lover_a,
      ?j => :move_left_lover_b,
      ?l => :move_right_lover_b,
      ?q => :exit,
      }
    end

    def tick
      check_contact
    end

    def exit_message
      "Bye!"
    end

    def wait?
    end

    def sleep_time
      0.5
    end

    def move_left_lover_a
      @lover_a.x -= 1
    end

    def move_right_lover_a
      @lover_a.x += 1
    end

    def move_left_lover_b
      @lover_b.x -= 1
    end

    def move_right_lover_b
      @lover_b.x += 1
    end

    def check_contact
     @textbox_content = contact? ? love_message : default_message
     show_hearts
    end

    def contact?
      @lover_a.x >= @lover_b.x - @lover_b.width
    end

    def show_hearts
      #objects + [Heart.new(25, 25)]
    end

    def love_message
      "_~*( make *LOVE* not war )*~_"
    end

    def default_message
      "Yo! Mista Lova Lova"
    end

    def exit
      Kernel.exit
    end
  end

end

Gaminator::Runner.new(ASCIILoving::Game).run
