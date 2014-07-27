require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

class GameWindow < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @player = Player.new(self)
    @enemy  = Enemy.new(self)
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
    @enemy.draw
  end

  def update
    scroll_background
    if button_down? Gosu::KbUp
      @player.y = [@player.y - 10, 0].max
    elsif button_down? Gosu::KbDown
      @player.y = [@player.y + 10, 475].min
    end
    @enemy.move
  end
end

class Player
  attr_accessor :y

  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
    @x = 50
    @y = 250
  end
end

class Enemy
  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
    @x = WINDOW_WIDTH
    @y = 0
  end

  def move
    @x -= 10
    @y = 400

    @x = WINDOW_WIDTH if @x < -100
  end

  def draw
    @image.draw(@x, @y, 0, 1, 1, 0xffff0000)
  end

end

window = GameWindow.new
window.show