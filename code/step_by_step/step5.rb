require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

class GameWindow < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @player = Player.new(self)
    @background = Gosu::Image.new(self, "../media/background.png")
    @background_x = 0
  end

  def scroll_background
    @background_x -= 10
    @background_x = 0 if @background_x < -(WINDOW_HEIGHT)
  end

  def draw
    @background.draw(@background_x, 0, 0)
    @player.draw
  end

  def update
    scroll_background
    if button_down? Gosu::KbUp
      @player.y = [@player.y - 10, 0].max
    elsif button_down? Gosu::KbDown
      @player.y = [@player.y + 10, 475].min
    end
  end
end

class Player
  attr_accessor :y

  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
    @x = 50
    @y = 250
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

window = GameWindow.new
window.show