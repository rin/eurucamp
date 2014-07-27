require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

class GameWindow < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @player = Player.new(self)
  end

  def draw
    @player.draw
  end

  def update
    p "updating ..."
  end
end

class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
  end

  def draw
    @image.draw(50, 250, 0)
  end
end

window = GameWindow.new
window.show